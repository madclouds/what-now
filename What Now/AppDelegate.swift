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

        Auth.auth().signInAnonymously { (authResult, _) in
            if let user = authResult?.user {
//                let isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                print("============================= "+uid)
            }
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainFactory().createMainModelView()
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}
