//
//  ConfirmViewController.swift
//  secured
//
//  Created by Ankur Sehdev on 21/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    typealias completionHandler = (_ passwordSet : Bool) -> ()
    var callback:completionHandler?
    var defaultPassOption = PasscodeOptions.FourDigits
    var passcode:String?
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var confirmField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        confirmField.keyboardType = defaultPassOption.keyboardType
        confirmField.becomeFirstResponder()
    }

   
    
    //MARK: - Button Actions
    @objc func closeTapped()  {
        if let cb = callback {
            cb(false)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let confirmPasscode = confirmField.text ?? ""
        if confirmPasscode.count == 0 || confirmPasscode.count < defaultPassOption.passcodeLimit
        {
            Helper.showAlert(Alerts.notComplete.rawValue, alertLabel)
            return
        }
        guard confirmPasscode == passcode else {
            Helper.showAlert(Alerts.mismatch.rawValue, alertLabel)
            return}
        let md5Base64 = EncryptorHelper.MD5(string: confirmPasscode)
        Helper.setDefaultsValueFor(value: md5Base64, key: defaultsKey.encryptedPasscode)
        Helper.setDefaultsValueFor(value: PasscodeStatus.active.rawValue, key: defaultsKey.passcodeStatus)
        Helper.setDefaultsValueFor(value: defaultPassOption.rawValue, key: defaultsKey.passcodeType)


        self.dismiss(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
}

//MARK: - Textdelegate Extensions
extension ConfirmViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard defaultPassOption != .AlphaNumeric else {
            return true
        }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= defaultPassOption.passcodeLimit
    }
}
