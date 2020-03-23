//
//  Helper.swift
//  secured
//
//  Created by Ankur Sehdev on 21/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

enum StoryBoard:String {
    case Main = "Main"
    case setupPasscode = "setupPasscode"
    case confirmPasscode = "confirmPasscode"
}

enum Alerts:String{
    case mismatch = "Passcode doesn't match"
    case notComplete = "Enter complete passcode"
    case wrongPasscode = "Wrong Passcode"
    
    static func wrongAlert(tries:Int) -> String{
        return tries == 1 ? "\(tries) failed attempt" : "\(tries) failed attempts"
    }
}

enum PasscodeStatus:String{
    case active
    case inactive
    
    var title:String{
        switch self {
        case .active:
            return "Enter Passcode"
        case .inactive:
            return "Setup Passcode"
        }
    }
    var btnTitle:String{
        switch self {
        case .active:
            return "Unlock"
        case .inactive:
            return "Next"
        }
    }
}

enum PasscodeOptions:String, CaseIterable{
    case FourDigits = "4-Digit Numeric Code"
    case SixDigits = "6-Digit Numeric Code"
    case AlphaNumeric = "Custom Alphanumeric"
    
    var passcodeLimit:Int{
        switch self {
        case .FourDigits:
            return 4
        case .SixDigits:
            return 6
        case .AlphaNumeric:
            return 0
        }
    }
    
    var keyboardType:UIKeyboardType{
        switch self{
        case .FourDigits:
            return .numberPad
        case .SixDigits:
            return .numberPad
        case .AlphaNumeric:
            return .emailAddress
        }
    }
    
    var passcodePlaceholder:String{
        switch self {
        case .FourDigits:
            return "Enter Passcode (4-Digits)"
        case .SixDigits:
            return "Enter Passcode (6-Digits)"
        case .AlphaNumeric:
            return "Enter Passcode (Alphanumeric)"
        }
    }
}

class Helper: NSObject {
    
    private static let animationTime = 1.5
    private static let delayAnimation = 1.0
    
    static var passcodeTryCounter = 0
    static var secLeft = 0

    // MARK: - Show Alert Label - Errors
    class func showAlert(_ message:String, _ alertLabel:UILabel){
        alertLabel.text = message
        UIView.animate(withDuration: animationTime) {
            alertLabel.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayAnimation) {
            UIView.animate(withDuration: animationTime) {
                alertLabel.alpha = 0
            }
        }
    }
    
    
  
    // MARK: - Generic VC getter
    class func getViewController<T:UIViewController>(identifier: String) -> T? {
        let storyBoard = UIStoryboard(name: StoryBoard.Main.rawValue, bundle: nil)
        let vController = storyBoard.instantiateViewController(identifier: identifier)
        return vController as? T
    }
    
    class func getDefaultsValueFor(key:defaultsKey) -> String{
        return UserDefaults.standard.value(forKey: key.rawValue) as? String ?? ""
    }
    
    class func setDefaultsValueFor(value:String, key:defaultsKey){
        UserDefaults.standard.set(value, forKey: key.rawValue)
//        UserDefaults.standard.synchronize()
    }
    
    class func checkTimeToKeepDisable() -> Bool{
        let nowTimestamp = Int(Date().toMillis())!
        let disabledTimestamp = Int(Helper.getDefaultsValueFor(key: .timestampPasscode)) ?? 0

        let sec = (nowTimestamp - disabledTimestamp)/1000
        let minutes = sec/60
        secLeft = disabledTimestamp == 0 ? 60 : 60 - sec

        return minutes >= 1 ? false : true
    }
    
    class func callTimer(completion: @escaping (Bool)->()){
        Timer.scheduledTimer(withTimeInterval: TimeInterval(secLeft), repeats: false) { timer in
            secLeft = 60
            passcodeTryCounter = 0
            Helper.setDefaultsValueFor(value: "", key: .timestampPasscode)
            completion(true)
        }
    }
    
}
extension UIViewController {
    static var topMostViewController : UIViewController {
        get {
            if let window = UIApplication.shared.keyWindow {
                return UIViewController.topViewController(rootViewController: window.rootViewController!)
            }
            else {
                return UIViewController()
            }
        }
    }
    private static func topViewController(rootViewController: UIViewController) -> UIViewController {
        guard rootViewController.presentedViewController != nil else {
            if rootViewController is UITabBarController {
                let tabbarVC = rootViewController as! UITabBarController
                let selectedViewController = tabbarVC.selectedViewController
                return UIViewController.topViewController(rootViewController: selectedViewController!)
            }
                
            else if rootViewController is UINavigationController {
                let navVC = rootViewController as! UINavigationController
                return UIViewController.topViewController(rootViewController: navVC.viewControllers.last!)
            }
            
            return rootViewController
        }
        
        return topViewController(rootViewController: rootViewController.presentedViewController!)
    }
}

extension UIAlertController{
    internal class func displayActionsheet (viewController: UIViewController = UIViewController.topMostViewController, title: String? = nil, message: String?, buttonTitle arrbtn:[PasscodeOptions], CompletionHandler comp:((_ index: Int, _ option:PasscodeOptions) -> Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for strTitle in arrbtn {
            let alertAction = UIAlertAction(title: strTitle.rawValue, style: UIAlertAction.Style.default, handler: { (action) in
                if let completion = comp, let title = action.title, let index = arrbtn.index(of: PasscodeOptions(rawValue: title)!) {
                    completion(index, arrbtn[index])
                }
            })
            alertVC.addAction(alertAction)
        }
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler : nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    
}

//MARK: - Date Extension
extension Date {
    func toMillis() -> String {
        return String(Int64(self.timeIntervalSince1970 * 1000))
    }
}
