//
//  SetupViewController.swift
//  secured
//
//  Created by Ankur Sehdev on 20/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    typealias completionHandler = (_ passwordSet : Bool) -> ()
    
    @IBOutlet weak var alertLabl: UILabel!
    var callback:completionHandler?
    @IBOutlet weak var disabledAlert: UILabel!
    @IBOutlet weak var passcodeField: UITextField!
    private var defaultPassOption = PasscodeOptions.FourDigits
    private var passcodeState = PasscodeStatus(rawValue: Helper.getDefaultsValueFor(key: defaultsKey.passcodeStatus)) ?? PasscodeStatus.inactive
    private var passcodeType = PasscodeOptions(rawValue: Helper.getDefaultsValueFor(key: defaultsKey.passcodeType))
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var passcodeOptionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = passcodeState.title
        nextBtn.setTitle(passcodeState.btnTitle, for: .normal)
        
        
        defaultPassOption = passcodeState == .active ? (passcodeType ?? defaultPassOption) : defaultPassOption
        self.passcodeField.placeholder = defaultPassOption.passcodePlaceholder
        self.passcodeField.keyboardType = defaultPassOption.keyboardType
        
        if passcodeState == .inactive{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
            passcodeOptionBtn.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passcodeField.becomeFirstResponder()
        if passcodeState == .active && Helper.checkTimeToKeepDisable(){
            disableApp()
        }
    }
    
    //MARK: - Button Actions
    @objc func closeTapped()  {
        if let cb = callback {
            cb(false)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if passcodeState == .inactive{
            let passcode = passcodeField.text ?? ""
            if passcode.count == 0 || passcode.count < defaultPassOption.passcodeLimit
            { return }
            let vController = Helper.getViewController(identifier: StoryBoard.confirmPasscode.rawValue) as! ConfirmViewController
            vController.callback = callback
            vController.passcode = passcodeField.text
            vController.defaultPassOption = self.defaultPassOption
            self.navigationController?.pushViewController(vController, animated: true)
        }
        else{
            let passcode = passcodeField.text ?? ""
            if passcode.count == 0 || passcode.count < defaultPassOption.passcodeLimit
            { return }
            
            let md5Passcode = EncryptorHelper.MD5(string: passcode)
            
            let savedPasscodeMd5 = Helper.getDefaultsValueFor(key: .encryptedPasscode)
            
            if md5Passcode == savedPasscodeMd5{
                Helper.passcodeTryCounter = 0
                self.dismiss(animated: true)
            }else{
                Helper.passcodeTryCounter += 1
                if (Helper.passcodeTryCounter >= 3) {
                    self.disableApp()
                    Helper.setDefaultsValueFor(value: Date().toMillis(), key: .timestampPasscode)
                }
                else{
                    Helper.showAlert(Alerts.wrongAlert(tries: Helper.passcodeTryCounter), alertLabl)
                }
                
            }
        }
    }
    
    func disableApp(){
        disabledAlert.isHidden = false
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.5
        Helper.callTimer {[weak self] (status) in
            if status {
                self?.enablePasscode()
            }
        }
    }
    
    @objc func enablePasscode()  {
        nextBtn.isEnabled = true
        nextBtn.alpha = 1
        disabledAlert.isHidden = true
    }
    
    @IBAction func passcodeOptionAction(_ sender: Any) {
        let arrOption = PasscodeOptions.allCases
        let avaialbleOptions = arrOption.filter{$0 != defaultPassOption}
        UIAlertController.displayActionsheet(viewController: self, title: nil, message: nil, buttonTitle: avaialbleOptions) {[weak self] (index, option) in
            self?.passcodeField.resignFirstResponder()
            self?.defaultPassOption = option
            self?.passcodeField.keyboardType = option.keyboardType
            self?.passcodeField.text = ""
            self?.passcodeField.placeholder = option.passcodePlaceholder
            self?.passcodeField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - Textdelegate Extensions
extension SetupViewController:UITextFieldDelegate{
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
