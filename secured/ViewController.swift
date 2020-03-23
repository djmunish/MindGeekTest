//
//  ViewController.swift
//  secured
//
//  Created by Ankur Sehdev on 20/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toggleBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let passcodeState = PasscodeStatus(rawValue: Helper.getDefaultsValueFor(key: defaultsKey.passcodeStatus)) ?? PasscodeStatus.inactive
        print("current pass code status \(passcodeState)")
        toggleBtn.isOn = passcodeState == .active ? true : false
        if  passcodeState == .active {
            openPassCodeController()
        }
    }

    
    @IBAction func toggleAction(_ sender: UISwitch) {
        
        if sender.isOn{
            let vController = Helper.getViewController(identifier: StoryBoard.setupPasscode.rawValue) as! SetupViewController
        
            vController.callback = { passSet in
                sender.setOn(passSet, animated: true)
            }
            let navController = UINavigationController(rootViewController: vController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
        else{
            Helper.setDefaultsValueFor(value: PasscodeStatus.inactive.rawValue, key: defaultsKey.passcodeStatus)
            UserDefaults.standard.removeObject(forKey: defaultsKey.encryptedPasscode.rawValue)
        }
    }
    
    func openPassCodeController(){
        let vController = Helper.getViewController(identifier: StoryBoard.setupPasscode.rawValue) as! SetupViewController
        let navController = UINavigationController(rootViewController: vController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
}

