//
//  AppDelegate.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {allowed, error in
            if allowed {
                //show notifications
            } else {
                //don't show notifications
            }
        }
        
        notificationCenter.removeAllPendingNotificationRequests()
        return true
    }
    
    func handleEvent(forRegion region: CLRegion) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            let message = region.identifier
            window?.rootViewController?.showAlert(withTitle: nil, message: message)
        } else {
            // Otherwise present a local notification
            let notification = UNMutableNotificationContent()
            notification.subtitle = region.identifier
            
            let request = UNNotificationRequest(identifier: "Notification", content: notification, trigger: nil)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print(error)
                }
            }
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }

}


extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
}
