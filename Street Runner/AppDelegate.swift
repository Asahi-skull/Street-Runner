//
//  AppDelegate.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/19.
//

import UIKit
import NCMB
import Firebase
import GoogleMobileAds
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NCMB.initialize(applicationKey: "3a79b85206e96f75cdee3fe8c51b1b715036101293aa8e0f26cdf1cd43d2b3f2", clientKey: "47d8a02a14592f461247dd308c14eaefbe0d64367530910f3bba35cd75af77d6")
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if((error) != nil) {
                    return
                }
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
        }

        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = NCMBInstallation.currentInstallation
        installation.setDeviceTokenFromData(data: deviceToken)
        installation.saveInBackground { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success:
                break
            case .failure(let error):
                let errorCode = (error as! NCMBApiError).errorCode
                if (errorCode == NCMBApiErrorCode.duplication) {
                    self.updateExistInstallation(installation: installation)
                }else if (errorCode == NCMBApiErrorCode.noDataAvailable) {
                    self.reRegistInstallation(installation: installation)
                }else{
                    return
                }
            }
        }
    }

    private func updateExistInstallation(installation: NCMBInstallation) -> Void {
        var installationQuery = NCMBInstallation.query
        installationQuery.where(field: "deviceToken", equalTo: installation.deviceToken!)
        installationQuery.findInBackground {
            switch $0 {
            case .success(let data):
                guard let searchDevice = data.first else {return}
                installation.objectId = searchDevice.objectId
                installation.saveInBackground {
                    switch $0 {
                    case .success:
                        break
                    case .failure:
                        return
                    }
                }
            case .failure:
                return
            }
        }
    }
    
    private func reRegistInstallation(installation: NCMBInstallation) -> Void {
        installation.objectId = nil
        installation.saveInBackground {
            switch $0 {
            case .success:
                break
            case .failure:
                return
            }
        }
    }
}

