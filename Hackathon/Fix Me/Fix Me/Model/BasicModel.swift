//
//  BasicModel.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import Foundation

struct VerificationModel: Decodable {
    let success: Bool?
    let isFirstTimeLogin: Bool?
}

struct RegistrationModel: Decodable {
    let success: Bool?
    let message: String?
}

//struct PostListModel: Decodable {
//    let success: Bool?
//    let donationsRequired: [DonationsRequired]?
//    let message: String?
//
//    enum CodingKeys: String, CodingKey {
//        case success = "success"
//        case message = "Message"
//        case donationsRequired = "donationsRequired"
//    }
//}
//
//struct DonationsRequired: Decodable {
//    let DonationRequestId: Int?
//    let userID: Int?
//    let title: String?
//    let amount: Int?
//    let amountRecieved: Int?
//    let amountCompletedPercentage: Int?
//    let category: Int?
//    let description: String?
//    let longitude: Double?
//    let latitude: Double?
////    let address: JSONNull?
//    let timeFrame: Int?
//    let image: String?
//    let status: String?
//    let user: User?
//
//    enum CodingKeys: String, CodingKey {
//        case DonationRequestId = "DonationRequestId"
//        case userID = "UserId"
//        case title = "Title"
//        case amount = "Amount"
//        case amountRecieved = "AmountRecieved"
//        case amountCompletedPercentage = "AmountCompletedPercentage"
//        case category = "Category"
//        case description = "Description"
//        case longitude = "Longitude"
//        case latitude = "Latitude"
////        case address = "Address"
//        case timeFrame = "TimeFrame"
//        case image = "Image"
//        case status = "Status"
//        case user = "User"
//    }
//}
//
//struct User: Decodable {
//    let mobileNumber: String?
//    let cnic: String?
//    let name: String?
//    let email: String?
//
//    enum CodingKeys: String, CodingKey {
//        case mobileNumber = "MobileNumber"
//        case cnic = "CNIC"
//        case name = "Name"
//        case email = "Email"
//    }
//}

struct PostListModel: Decodable {
    let success: Bool?
    let donationsRequired: [DonationsRequired]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case donationsRequired = "donationsRequired"
    }
}

struct DonationsRequired: Decodable {
    let donationRequestID: Int?
    let userID: Int?
    let title: String?
    let amount: Int?
    let amountRecieved: Int?
    let amountCompletedPercentage: Double?
    let category: Int?
    let description: String?
    let longitude: Double?
    let latitude: Double?
    let address: String?
    let timeFrame: Int?
    let image: String?
    let status: String?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case donationRequestID = "DonationRequestId"
        case userID = "UserId"
        case title = "Title"
        case amount = "Amount"
        case amountRecieved = "AmountRecieved"
        case amountCompletedPercentage = "AmountCompletedPercentage"
        case category = "Category"
        case description = "Description"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case address = "Address"
        case timeFrame = "TimeFrame"
        case image = "Image"
        case status = "Status"
        case user = "User"
    }
}

struct User: Decodable {
    let mobileNumber: String?
    let cnic: String?
    let name: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case mobileNumber = "MobileNumber"
        case cnic = "CNIC"
        case name = "Name"
        case email = "Email"
    }
}

//struct PostListModel: Decodable {
//    let success: Bool?
//    let message: String?
//    let donationsRequired: [DonationsRequired]?
//}
//
//struct DonationsRequired: Decodable {
//    let DonationRequestId: Int?
//    let userId: Int?
//    let title: String?
//    let amount: Int?
//    let amountRecieved: Int?
//    let amountCompletedPercentage: Int?
//    let category: Int?
//    let description: String?
//    let longitude: Double?
//    let latitude: Double?
////    let address: String?
//    let timeFrame: Int?
//    let image: String?
//    let user: User?
//}
//
//struct User: Decodable {
//    let mobileNumber: String?
//    let cnic: String?
//    let name: String?
//    let email: String?
//}

