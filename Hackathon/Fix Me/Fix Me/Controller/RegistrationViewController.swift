//
//  RegistrationViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import Material

class RegistrationViewController: UIViewController {

    @IBOutlet weak var name: TextField!
    @IBOutlet weak var CNIC: TextField!
    @IBOutlet weak var email: TextField!
    
    var registrationData = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To hide navigationBar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.isHidden = false
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if registrationData["instanceId"] != nil {
            if registrationData["key"] != nil {
                if registrationData["number"] != nil {
                    if checkFields() {
                        let instanceId = registrationData["instanceId"]
                        let key = registrationData["key"]
                        let number = registrationData["number"]
                        
                        var e = ""
                        if let text = email.text {
                            e = text
                        }
                        spinner = showActivityIndicator(view: self.view)
                        
                        AuthService.instance.registerUser(MobileNumber: number!, MobileInstanceId: instanceId!, MobileKey: key!, EmailAddress: e, Name: name.text!, CNIC: CNIC.text!, errorMessage: {
                        (message) in
                            if let mes = message {
                                spinner?.dismissLoader()
                                self.displayAlert(title: BUSINESS_NAME, message: mes)
                            }
                        }, completion: { (success) in
                            if success {
                                AuthService.instance.mobileNumber = number!
                                AuthService.instance.isLoggedIn = true
                                self.performSegue(withIdentifier: "toHome", sender: nil)
                            } else {
                                spinner?.dismissLoader()
                                self.displayAlert(title: BUSINESS_NAME, message: ERROR_MESSAGE)
                            }
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }

    func checkFields() -> Bool {
        if name.text != "" {
            if CNIC.text != "" && CNIC.text?.count == 15 {
                return true
            } else {
                self.displayAlert(title: BUSINESS_NAME, message: "Please provide correct CNIC")
            }
        } else {
            self.displayAlert(title: BUSINESS_NAME, message: "Please provide your name")
        }
        return false
    }
}
