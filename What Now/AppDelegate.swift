//
//  AppDelegate.swift
//  What Now
//
//  Created by Erik Bye on 6/3/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainFactory().createMainModelView()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
