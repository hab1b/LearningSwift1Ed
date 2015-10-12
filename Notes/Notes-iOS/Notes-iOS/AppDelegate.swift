//
//  AppDelegate.swift
//  Notes-iOS
//
//  Created by Jonathon Manning on 25/08/2015.
//  Copyright © 2015 Jonathon Manning. All rights reserved.
//

import UIKit

// BEGIN settings_notification_name
let NotesApplicationDidRegisterUserNotificationSettings = "NotesApplicationDidRegisterUserNotificationSettings"
// END settings_notification_name

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // BEGIN access_to_icloud
        // Ensure we've got access to iCloud
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock() {
            // Pass 'nil' to this method to get the URL for the first
            // iCloud container listed in the app's entitlements
            let ubiquityContainerURL = NSFileManager.defaultManager()
                .URLForUbiquityContainerIdentifier(nil)
            print("Ubiquity container URL: \(ubiquityContainerURL)")
        }
        // END access_to_icloud
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // BEGIN open_url
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.scheme == "notes", let path = url.path {
            
            // Return to the list of documents
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                
                navigationController.popToRootViewControllerAnimated(false)
                
                 (navigationController.topViewController as? DocumentListViewController)?.openDocumentWithPath(path)
            }
            
            return true
            
        }
        
        return false
    }
    // END open_url
    
    // BEGIN local_notification_received
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        // Extract the document and open it
        if notification.category == Document.alertCategory,
            let url = notification.userInfo?["owner"] as? String,
            let navigationController = self.window?.rootViewController as? UINavigationController
            {
            if let path = NSURL(string: url)?.path {
                navigationController.popToRootViewControllerAnimated(false)
                
                (navigationController.topViewController as? DocumentListViewController)?.openDocumentWithPath(path)
            }
        }
        
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if identifier == Document.alertSnoozeAction {
            // Reschedule the notification
            notification.fireDate = NSDate(timeIntervalSinceNow: 5)
            application.scheduleLocalNotification(notification)
        }
        
        completionHandler();
    }
    // END local_notification_received

    
    
    
    // BEGIN application_continue_activity
    func application(application: UIApplication,
        continueUserActivity userActivity: NSUserActivity,
        restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        // Return to the list of documents
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewControllerAnimated(false)
            
            // We're now at the list of documents; tell the restoration 
            // system that this view controller needs to be informed
            // that we're continuing the activity
            if let topViewController = navigationController.topViewController {
                restorationHandler([topViewController])
            }
            
            
            
            return true
        }
        return false
    }
    // END application_continue_activity
    
    // BEGIN application_did_register
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotesApplicationDidRegisterUserNotificationSettings, object: self)
    }
    // END application_did_register
    
    
    
    
}

