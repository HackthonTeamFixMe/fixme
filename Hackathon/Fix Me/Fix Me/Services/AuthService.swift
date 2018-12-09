//
//  AuthService.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        } set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var instanceId: String? {
        get {
            return defaults.value(forKey: INSTANCE_ID_KEY) as? String
        } set {
            defaults.set(newValue, forKey: INSTANCE_ID_KEY)
        }
    }
    
    var userId: String? {
        get {
            return defaults.value(forKey: USER_ID) as? String
        } set {
            defaults.set(newValue, forKey: USER_ID)
        }
    }
    
    var phoneVerificationId: String? {
        get {
            return defaults.value(forKey: VERIFICATION_ID_KEY) as? String
        } set {
            defaults.set(newValue, forKey: VERIFICATION_ID_KEY)
        }
    }
    
    var accessToken: String? {
        get {
            return defaults.value(forKey: ACCESS_TOKEN) as? String
        } set {
            defaults.set(newValue, forKey: ACCESS_TOKEN)
        }
    }
    
    var mobileNumber: String? {
        get {
            return defaults.value(forKey: MOBILE_NUMBER_KEY) as? String
        } set {
            defaults.set(newValue, forKey: MOBILE_NUMBER_KEY)
        }
    }
    
    func accountVerification(mobileNo: String, isFirstLogin: @escaping CompletionHandler, completion: @escaping CompletionHandler) {
        
        let body: Parameters = [
            "mobileNo": mobileNo
        ]
        
        print("\nBody: \(body)\n")
        print("URL: \(ACCOUNT_VERIFICATION)\n")
        
        
        Alamofire.request(ACCOUNT_VERIFICATION, method: .get, parameters: body).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    
                    let verification = try JSONDecoder().decode(VerificationModel.self, from: data)
                    
                    if let success = verification.success {
                        if success {
                            if let firstLogin = verification.isFirstTimeLogin {
                                if firstLogin {
                                    isFirstLogin(true)
                                } else {
                                    isFirstLogin(false)
                                }
                            }
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch _ {
                    completion(false)
                }
                
            } else {
                completion(false)
            }
        }
    }
    
    func registerUser(MobileNumber: String, MobileInstanceId: String, MobileKey: String, EmailAddress: String, Name: String, CNIC: String, errorMessage: @escaping ErrorMessageHandler, completion: @escaping CompletionHandler) {
        
        let body: Parameters = [
            "MobileNumber": MobileNumber,
            "MobileInstanceId": MobileInstanceId,
            "MobileKey": MobileKey,
            "EmailAddress": EmailAddress,
            "Name": Name,
            "CNIC": CNIC
        ]
        
        print("\nBody: \(body)\n")
        print("URL: \(REGISTER_USER)\n")
        
        Alamofire.request(REGISTER_USER, method: .post, parameters: body).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    
                    let verification = try JSONDecoder().decode(RegistrationModel.self, from: data)
                    
                    if let success = verification.success {
                        if success {
                            completion(true)
                        } else {
                            if let message = verification.message {
                                errorMessage(message)
                            }
                        }
                    }
                } catch _ {
                    completion(false)
                }
                
            } else {
                completion(false)
            }
        }
    }
    
    func getToken(MobileNumber: String, errorMessage: @escaping ErrorMessageHandler, completion: @escaping CompletionHandler) {
        
        let body: Parameters = [
            "username": MobileNumber,
            "grant_type": "password"
        ]
        
        print("\nBody: \(body)\n")
        print("URL: \(GET_TOKEN)\n")
        
        Alamofire.request(GET_TOKEN, method: .post, parameters: body).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let value = response.value else { return }
                if let data = value as? Dictionary<String, Any> {
                    if let access_token = data["access_token"] as? String {
                        self.accessToken = access_token
                    }
                    if let userId = data["userId"] as? String {
                        self.userId = userId
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func addPost(Title: String, Amount: String, Category: String, Description: String, Longitude: String, Latitude: String, TimeFrame: String, Image: Data, errorMessage: @escaping ErrorMessageHandler, completion: @escaping CompletionHandler) {
        
        print("URL: \(ADD_POST)\n")
        Alamofire.upload(multipartFormData: { (mData) in
            
            mData.append(Title.data(using: String.Encoding.utf8)!, withName: "Title")
            mData.append(Amount.data(using: String.Encoding.utf8)!, withName: "Amount")
            mData.append(Category.data(using: String.Encoding.utf8)!, withName: "Category")
            mData.append(Description.data(using: String.Encoding.utf8)!, withName: "Description")
            mData.append(Longitude.data(using: String.Encoding.utf8)!, withName: "Longitude")
            mData.append(Latitude.data(using: String.Encoding.utf8)!, withName: "Latitude")
            mData.append(TimeFrame.data(using: String.Encoding.utf8)!, withName: "TimeFrame")
            mData.append(self.userId!.data(using: String.Encoding.utf8)!, withName: "UserId")
            mData.append(Image, withName: "Image", fileName: "file.jpg", mimeType: "image/jpg")
            
        }, usingThreshold: UInt64.init(), to: ADD_POST, method: .post) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    
                    if response.result.error == nil {
                        
                        guard let value = response.value as? Dictionary<String, Any> else { return }
                        if let success = value["success"] as? Bool {
                            if success {
                                completion(true)
                            } else {
                                if let message = value["message"] as? String {
                                    errorMessage(message)
                                }
                            }
                        }
                    }
                })
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func getPosts(id: Int, dataModel: @escaping (PostListModel) -> (), errorMessage: @escaping ErrorMessageHandler, completion: @escaping CompletionHandler) {
        
        let body: Parameters = [
            "category": id
        ]
        
        print("\nBody: \(body)\n")
        print("URL: \(GET_POST)\n")
        
        
        Alamofire.request("\(GET_POST)/\(id)", method: .get).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    
                    let verification = try JSONDecoder().decode(PostListModel.self, from: data)
                    
                    if let success = verification.success {
                        if success {
                            dataModel(verification)
                            completion(true)
                        } else {
                            if let message = verification.message {
                                errorMessage(message)
                                return
                            }
                            completion(false)
                        }
                    }
                } catch _ {
                    completion(false)
                }
                
            } else {
                completion(false)
            }
        }
    }
}
