//
//  HomeViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var initiatorButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //To hide navigationBar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonViews()
        
        if let number = AuthService.instance.mobileNumber {
            AuthService.instance.getToken(MobileNumber: number, errorMessage: { (message) in
                
            }) { (success) in
                
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        AuthService.instance.isLoggedIn = false
        let board: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userPortal = board.instantiateViewController(withIdentifier: "loginVC")
        self.present(userPortal, animated: true, completion: nil)
    }
    
    @IBAction func donorButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toDonor", sender: nil)
    }
    
    @IBAction func initiatorButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toInitiator", sender: nil)
    }
    
    func setupButtonViews() {
        donorButton.layer.cornerRadius = 100
        initiatorButton.layer.cornerRadius = 100
    }
    

}
