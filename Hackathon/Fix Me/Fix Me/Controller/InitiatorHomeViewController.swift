//
//  InitiatorHomeViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import CircleMenu

class InitiatorHomeViewController: UIViewController, CircleMenuDelegate {

    @IBOutlet weak var containerImage: UIImageView!
    @IBOutlet weak var circularButton: CircleMenu!
    
    let items: [(icon: String, color: UIColor, value: Int)] = [
        ("education", UIColor(red: 0.77, green: 0.14, blue: 0.20, alpha: 1), 1),
        ("health", UIColor(red: 0.18, green: 0.60, blue: 0.30, alpha: 1), 2),
        ("cities", UIColor(red: 0.95, green: 0.43, blue: 0.20, alpha: 1), 3),
        ("infra", UIColor(red: 0.97, green: 0.61, blue: 0.22, alpha: 1), 4)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //To hide navigationBar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.isHidden = false
        }
        
        setupButtonViews()
        
        
        circularButton.delegate = self
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        
        let image = button.image(for: .normal)
        let color = items[atIndex].color
        let value = items[atIndex].value
        
        let data = ["image": image!, "value": value,"color": color] as [String : Any]
        
        self.performSegue(withIdentifier: "toPost", sender: data)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            if let dest = segue.destination as? PostViewController {
                dest.data = sender as! [String : Any]
            }
        }
    }
    
    func setupButtonViews() {
        containerImage.layer.cornerRadius = 40
        circularButton.layer.cornerRadius = 40
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    

}
