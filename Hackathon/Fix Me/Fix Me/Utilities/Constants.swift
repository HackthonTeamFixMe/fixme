//
//  Constants.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import Foundation

let BUSINESS_NAME = "Fix Me"
let BASE_URL = "https://service-fixme.azurewebsites.net/"

//Message
let ERROR_MESSAGE = "Oops, something went wrong!"

//URL
let ACCOUNT_VERIFICATION = "\(BASE_URL)api/account/verify"
let REGISTER_USER = "\(BASE_URL)api/account/register"
let GET_TOKEN = "\(BASE_URL)api/token"
let ADD_POST = "\(BASE_URL)api/donation/request"
let GET_POST = "\(BASE_URL)api/donations"
let CREATE_DONATION = "\(BASE_URL)api/donation/create"
let GET_USER_POSTS = "\(BASE_URL)api/donations/user"

//Keys
let BUNDLE_ID = "com.hackathon.Fix-Me"
let INSTANCE_ID_KEY = "\(BUNDLE_ID).instanceId"
let LOGGED_IN_KEY = "\(BUNDLE_ID).loggedInKey"
let VERIFICATION_ID_KEY = "\(BUNDLE_ID).verificationIdKey"
let MOBILE_NUMBER_KEY = "\(BUNDLE_ID).mobileNumberKey"
let ACCESS_TOKEN = "\(BUNDLE_ID).accessToken"
let USER_ID = "\(BUNDLE_ID).userIdKey"

//Compeltion handler
typealias CompletionHandler = (_ Success: Bool) -> ()
typealias ErrorMessageHandler = (_ message: String?) -> ()
