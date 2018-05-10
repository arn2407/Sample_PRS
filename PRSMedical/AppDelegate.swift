//
//  AppDelegate.swift
//  PRSMedical
//
//  Created by Arun Kumar on 11/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

var isGoogleSignIn = false
var isFacebookSignIn = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let loader : ApplicationLoader = {
        let hud = ApplicationLoader()
        return hud
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let path = Bundle.main.path(forResource: "credentials", ofType: "plist") , let  dict = NSDictionary(contentsOfFile: path) , let clientID = dict["CLIENT_ID"] as? String
        {
            GIDSignIn.sharedInstance().clientID = clientID
        }
        
      
        if let isAppFirstRun = getValue(forKey: .firstRun) as? Bool , !isAppFirstRun
        {
            moveToSecondRoot()
        }
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }

    
    func moveToSecondRoot() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.viewController() as SecondRunRootViewController
        
        let nav = UINavigationController(rootViewController: home)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
      
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let _ = (window?.rootViewController as? UINavigationController)?.viewControllers.last as? MainTabBarViewController
        {
            postNotification(notification: .forgroundUpdate ,object: completionHandler)
        }
        else
        {
            completionHandler(.noData)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if isGoogleSignIn
        {
        return  GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as? String)
        }
        if isFacebookSignIn
        {
            return  FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)

        }
        return false
        
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
        postNotification(notification: .disconnectCushion)
        CoreDataStack.dataStack.saveContext()
    }



}

let sharedApp = UIApplication.shared.delegate as! AppDelegate


