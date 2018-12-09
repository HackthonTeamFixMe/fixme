//
//  PostViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import Material
import CoreLocation

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topOuterContainerView: UIView!
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var titleTextField: TextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amount: TextField!
    @IBOutlet weak var chooseLocationButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    var imageURL: String?
    var imageData: Data?
    
    var data = [String : Any]()
    var titleValue: Int?
    
    var numbers = [Int]()
    var values = [String]()
    
    var selectedNumber: Int?
    var selectedValue: String?
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    var finalNumber: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        self.numbers.removeAll()
        for i in 1...31 {
            self.numbers.append(i)
        }
        values.removeAll()
        values.append("Day")
        values.append("Week")
        values.append("Month")
        values.append("Year")

        if let number = self.numbers.first {
            self.selectedNumber = number
        }
        if let value = self.values.first {
            self.selectedValue = value
        }
        
        self.chooseLocationButton.layer.cornerRadius = 10
        if let image = data["image"] as? UIImage {
            self.goalImage.image = image
        }
        if let color = data["color"] as? UIColor {
            self.descriptionTextView.layer.cornerRadius = 5
            self.descriptionTextView.layer.backgroundColor = UIColor.white.cgColor
            self.saveButton.layer.backgroundColor = color.cgColor
            self.chooseLocationButton.layer.backgroundColor = color.cgColor
            self.topContainerView.layer.backgroundColor = color.cgColor
            self.topOuterContainerView.layer.backgroundColor = color.cgColor
        }
        if let title = data["value"] as? Int {
            self.titleValue = title
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        setupProfilePicture()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    //Image picker delegate method
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage]
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectImage.image = image
        }
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL {
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)
                let photoURL = URL.init(fileURLWithPath: localPath!)
                self.imageURL = photoURL.absoluteString
                
            }
        } else {
            // Fallback on earlier versions
            if let imgUrl = info[UIImagePickerControllerReferenceURL] as? URL {
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)
                let photoURL = URL.init(fileURLWithPath: localPath!)
                self.imageURL = photoURL.absoluteString
                
            }
        }
        self.imageData = UIImagePNGRepresentation(chosenImage as! UIImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseLocationPressed(_ sender: Any) {

        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            guard let currentLocation = locationManager?.location else { return }
            self.chooseLocationButton.setTitle("Location Found", for: .normal)
            self.currentLocation = currentLocation
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        self.convertTimeFrame()
        if let number = self.finalNumber {
            if checkFields() {
                spinner = showActivityIndicator(view: self.view)
                
                AuthService.instance.addPost(Title: self.titleTextField.text!, Amount: self.amount.text!, Category: "\(self.titleValue!)", Description: self.descriptionTextView.text!, Longitude: "\(currentLocation!.coordinate.longitude)", Latitude: "\(currentLocation!.coordinate.latitude)", TimeFrame: "\(number)", Image: self.imageData!, errorMessage: { (message) in
                    if let msg = message {
                        spinner?.dismissLoader()
                        self.displayAlert(title: BUSINESS_NAME, message: msg)
                    }
                }) { (success) in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        spinner?.dismissLoader()
                    } else {
                        spinner?.dismissLoader()
                        self.displayAlert(title: BUSINESS_NAME, message: ERROR_MESSAGE)
                    }
                }
            }
        }
    }
    
    //Profile picture setup
    func setupProfilePicture() {
        self.selectImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choosePicturePressed)))
        self.selectImage.clipsToBounds = true
        self.selectImage.layer.cornerRadius = 5
    }
    
    //Choose picture from gallery
    @objc func choosePicturePressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (success) in
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (success) in
            let picker = UIImagePickerController.init()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension PostViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return numbers.count
        } else {
            return values.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(numbers[row])"
        } else {
            return values[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.selectedNumber = numbers[row]
        } else {
            self.selectedValue = values[row]
        }
    }
    
    func convertTimeFrame() {
        if let number = self.selectedNumber {
            if let value = self.selectedValue {
                if value.lowercased() == "day" {
                    self.finalNumber = number
                }
                if value.lowercased() == "week" {
                    self.finalNumber = number * 7
                }
                if value.lowercased() == "month" {
                    self.finalNumber = number * 30
                }
                if value.lowercased() == "year" {
                    self.finalNumber = number * 365
                }
            }
        }
    }
    
    func checkFields() -> Bool {
        
        if let _ = self.imageData {
            if self.titleTextField.text != "" {
                if self.descriptionTextView.text != "" {
                    if self.amount.text != "" {
                        if let t = self.chooseLocationButton.title(for: .normal) {
                            if t.lowercased() == "location found" {
                                return true
                            } else {
                                self.displayAlert(title: BUSINESS_NAME, message: "Please click location button.")
                            }
                        }
                    } else {
                        self.displayAlert(title: BUSINESS_NAME, message: "Please provide some amount.")
                    }
                } else {
                    self.displayAlert(title: BUSINESS_NAME, message: "Please provide some description.")
                }
            } else {
                self.displayAlert(title: BUSINESS_NAME, message: "Please provide a title.")
            }
        } else {
            self.displayAlert(title: BUSINESS_NAME, message: "Please upload an image.")
        }
        
        return false
    }
}
