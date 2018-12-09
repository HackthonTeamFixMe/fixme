//
//  ViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging
import FirebaseInstanceID
import DGActivityIndicatorView

//Activity spinner
var spinner: DGActivityIndicatorView?

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var backArrowButton: UIButton!
    @IBOutlet weak var phoneCodeNumber: UIButton!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    fileprivate var timerForResend: Timer?
    var phoneNumber: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To hide navigationBar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.isHidden = true
        }
        
        setupContainerView()
    }
    
    //DimView
    var dimView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0
        return v
    }()
    
    //Phone verification backArrow button setup
    @IBAction func backButtonPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        spinner = showActivityIndicator(view: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.phoneCodeNumber.isHidden = false
            self.lineView.isHidden = false
            self.numberField.text = ""
            self.numberField.placeholder = "313XXXXXXX"
            self.authenticateButton.setTitle("Authenticate", for: .normal)
            self.backArrowButton.isHidden = true
            self.resendButton.isHidden = true
            if let timer = self.timerForResend {
                timer.invalidate()
            }
            spinner?.dismissLoader()
        }
    }
    
    //Resend button setup
    @IBAction func resendButtonPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        if let number = self.phoneNumber {
            sendVerficationCode(phoneNumber: number)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegistration" {
            if let dest = segue.destination as? RegistrationViewController {
                dest.registrationData = sender as! [String: String]
            }
        }
    }
    
    //Number authentication
    @IBAction func authenticateButtonPressed(_ sender: Any) {
        if let title = self.authenticateButton.title(for: .normal) {
            if title == "Verify" {
                if let verificationId = AuthService.instance.phoneVerificationId {
                    if self.numberField != nil {
                        if self.numberField.text != "" {
                            self.view.endEditing(true)
                            
                            self.view.addSubview(self.dimView)
                            self.dimView.frame = CGRect(x: 0, y: 0, width: 2000, height: 2000)
                            self.dimView.center = self.view.center
                            spinner = self.showActivityIndicator(view: self.view)
                            self.addAnimationToDimView(duration: 0.7, animationStyle: .curveEaseOut, view: self.dimView, isHidding: false)
                            
                            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: self.numberField.text!)
                            
                            Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
                                if error == nil {
                                    if let r = result {
                                        guard let insId = AuthService.instance.instanceId else { return }
                                        guard let phoneNumber = r.user.phoneNumber else { return }
                                        let key = r.user.uid
                                        
                                        var number = phoneNumber
                                        number.insert("-", at: number.index(number.endIndex, offsetBy: -10))
                                        
                                        print("Instance Id: \(insId)")
                                        print("key: \(key)")
                                        print("Number: \(number)")
                                        
                                        AuthService.instance.accountVerification(mobileNo: number, isFirstLogin: { (success) in
                                            if success {
                                                let sender = ["instanceId": insId, "key": key, "number": number]
                                                AuthService.instance.mobileNumber = number
                                                self.performSegue(withIdentifier: "toRegistration", sender: sender)
                                            } else {
                                                AuthService.instance.mobileNumber = number
                                                AuthService.instance.isLoggedIn = true
                                            }
                                        }, completion: { (success) in
                                            if success {
                                                spinner?.dismissLoader()
                                                self.addAnimationToDimView(duration: 0.5, animationStyle: .curveEaseOut, view: self.dimView, isHidding: true)
                                            } else {
                                                spinner?.dismissLoader()
                                                self.addAnimationToDimView(duration: 0.5, animationStyle: .curveEaseOut, view: self.dimView, isHidding: true)
                                                self.displayAlert(title: BUSINESS_NAME, message: ERROR_MESSAGE)
                                            }
                                        })
                                        
                                    }
                                } else {
                                    spinner?.dismissLoader()
                                    self.addAnimationToDimView(duration: 0.5, animationStyle: .curveEaseOut, view: self.dimView, isHidding: true)
                                    self.displayAlert(title: BUSINESS_NAME, message: (error?.localizedDescription)!)
                                }
                            }
                            
                        } else {
                            self.displayAlert(title: BUSINESS_NAME, message: "You have not provided any number.")
                        }
                    } else {
                        self.displayAlert(title: BUSINESS_NAME, message: "You have not provided any number.")
                    }
                } else {
                    self.displayAlert(title: BUSINESS_NAME, message: "Try agin.")
                }
                
            } else {
                if self.numberField != nil {
                    if self.numberField.text != "" {
                        if self.numberField.text?.count == 10 {
                            self.view.endEditing(true)
                            let alertSheet = UIAlertController(title: "Phone Number", message: "Is this your phone number? \n\(self.phoneCodeNumber.title(for: .normal)! + self.numberField.text! )", preferredStyle: .alert)
                            
                            let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
                                spinner = self.showActivityIndicator(view: self.view)
                                if let titleLabel = self.phoneCodeNumber.titleLabel {
                                    if let text = titleLabel.text {
                                        let n = "\(text)-"
                                        let number = "\(n)\(self.numberField.text!)"
                                        self.sendVerficationCode(phoneNumber: number)
                                    }
                                }
                            }
                            
                            let no = UIAlertAction(title: "No", style: .default) { (action) in
                                print("Cancelled")
                            }
                            
                            alertSheet.addAction(no)
                            alertSheet.addAction(yes)
                            self.present(alertSheet, animated: true, completion: nil)
                        } else {
                            self.displayAlert(title: "You need to put 10 digit phone number.", message: "")
                        }
                    } else {
                        self.displayAlert(title: BUSINESS_NAME, message: "You have not provided any number.")
                    }
                } else {
                    self.displayAlert(title: BUSINESS_NAME, message: "You have not provided any number.")
                }
                
            }
        }
    }


}

extension ViewController {
    
    func setupContainerView() {
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowRadius = 8.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.35
    }
    
    //Send verification code stup
    func sendVerficationCode(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        if (spinner?.isHidden)! {
            spinner = self.showActivityIndicator(view: self.view)
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber("\(phoneNumber)", uiDelegate: nil, completion: { (verificationId, error) in
            if error == nil {
                spinner?.dismissLoader()
                self.timerForResend = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] (timer) in
                    self?.resendButton.isHidden = false
                }
                self.numberField.placeholder = "XXXXXX"
                self.authenticateButton.setTitle("Verify", for: .normal)
                AuthService.instance.phoneVerificationId = verificationId
                self.phoneCodeNumber.isHidden = true
                self.lineView.isHidden = true
                self.numberField.text = ""
                self.backArrowButton.isHidden = false
            } else {
                spinner?.dismissLoader()
                self.displayAlert(title: BUSINESS_NAME, message: (error?.localizedDescription)!)
            }
        })
    }
}

