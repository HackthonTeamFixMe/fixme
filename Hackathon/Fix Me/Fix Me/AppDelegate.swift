//
//  AppDelegate.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Changing statusBarColor
        UIApplication.shared.statusBarStyle = .lightContent
        
        checkLoggedInStatus()
        
        //Push notification setup
        firebasePushNotificationSetup(application: application)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        firebaseHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//AppDelegate extension
extension AppDelegate: UNUserNotificationCenterDelegate {

    //Remebering loggedin user
    func checkLoggedInStatus() {
        //        AuthService.instance.isLoggedIn = false
        if !rememberUser() {
            let board: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let userPortal = board.instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = userPortal
        }
        
        if AuthService.instance.instanceId == nil {
            let board: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let userPortal = board.instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = userPortal
        }
    }
    
    func rememberUser() -> Bool {
        let isLoggedIn = AuthService.instance.isLoggedIn
        
        if isLoggedIn {
            let board: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let userPortal = board.instantiateViewController(withIdentifier: "homeVC")
            window?.rootViewController = userPortal
            return true
        } else {
            return false
        }
    }
    
    //Push notification setup
    func firebasePushNotificationSetup(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if error == nil {
                print("Successful Authorizations")
            }
        }
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
    
    @objc func refreshToken(notification: NSNotification) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                if let r = result {
                    AuthService.instance.instanceId = r.token
                } else {
                    print("Something wrong with firebase notifications.")
                }
            } else {
                print("Something wrong with firebase notifications.")
            }
        })
        firebaseHandler()
    }
    
    func firebaseHandler() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
