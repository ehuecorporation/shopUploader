//
//  AppDelegate.swift
//  shopDataUploader
//
//  Created by 蕭　喬仁 on 2017/03/23.
//  Copyright © 2017年 蕭　喬仁. All rights reserved.
//

import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // mbのAPIキー
    NCMB.setApplicationKey("644a6ccf8f9fa7c5f792d301adf624a7fe6d7455996b92de01a46037a84723a5", clientKey: "4c5771973e8c4818e5296e2aed38d2325e0fdfaad584b5560200830eaf88add6")
        NCMBTwitterUtils.initialize(withConsumerKey: "UVGEnYxLfLudJlCEVwcMDHo2C", consumerSecret: "Ot5yjc9N7jTxYLCa52nV8eRYYVvcByXCsqMZMj0Rb7NVYeyyir")
        return true
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
    }


}

