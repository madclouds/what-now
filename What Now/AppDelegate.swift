//
//  AppDelegate.swift
//  What Now
//
//  Created by Erik Bye on 6/3/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
import Firebase
import Billboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let viewControllerFactory: ViewControllerFactory
    var window: UIWindow?

    override init() {
        Billboard.printSomething()
        NotificationService.setUpLocalNotification()
        let databaseServices = LocalStorageDatabaseService()
        viewControllerFactory = ViewControllerFactory(databaseService: databaseServices)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewControllerFactory.main()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
