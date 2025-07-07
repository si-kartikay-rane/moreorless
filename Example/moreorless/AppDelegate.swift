//
//  AppDelegate.swift
//  moreorless
//
//  Created by si-kartikay-rane on 07/07/2025.
//  Copyright (c) 2025 si-kartikay-rane. All rights reserved.
//

import UIKit
import GamesLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GamingHubCards.setupPOC(competition: 1, environment: .integration)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: deeplinking
    // custom scheme uefa-gaminghub-poc::
    
    /// This method is handling links received through your app's custom URL scheme.
    /// This method is also called when your app is opened for the first time after installation.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("DEEPLINK openURL \(url)")
        return process(url: url)
    }
    
    /// Handles universal link calls and forced touch previews.
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("DEEPLINK userActivity \(userActivity.webpageURL?.absoluteString ?? "-")")
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else {
            print("DEEPLINK UTMLINK - request rejected")
            return false
        }
        
        return process(url: url)
    }
    
    func process(url: URL)->Bool{
        guard url.absoluteString.contains("moreorless") else { return false }
        
        if CurrentGame == "moreorless" {
            // the game is already opened
            NotificationCenter.default.post(name: .ghOpenLink, object: nil, userInfo: ["url":url])
        }else{
            GamingHubCards.open("moreorless", data: ["url":url])
        }
        
        return true
    }
}

