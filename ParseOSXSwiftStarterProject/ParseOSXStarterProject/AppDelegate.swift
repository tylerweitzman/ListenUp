//
//  AppDelegate.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import Cocoa

import Bolts
import ParseOSX

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Enable storing and querying data from Local Datastore. 
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()

        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        
        Parse.setApplicationId("PsO5rkxMEaRvzzig7IKiQgfpQVRNdQFpPYO9Ipg0", clientKey: "4HM92cKDqZrv5yc7c6ha5KcvA9L8w9NXTnX9Uyl3")
        // ****************************************************************************

        PFUser.enableAutomaticUser()

        let defaultACL: PFACL = PFACL()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)

        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)

        // ****************************************************************************
        // Uncomment these lines to register for Push Notifications.
        //
        // let types = NSRemoteNotificationType.Alert |
        //             NSRemoteNotificationType.Badge |
        //             NSRemoteNotificationType.Sound;
        // NSApplication.sharedApplication().registerForRemoteNotificationTypes(types)
        //
        // ****************************************************************************

        PFAnalytics.trackAppOpenedWithLaunchOptions(nil)
    }

    func application(application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()

        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                println("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                println("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }

    func application(application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }

    func application(application: NSApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    }

}



