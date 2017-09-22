//
//  AppDelegate.swift
//  ARKitDemo
//
//  Created by Todd Olsen on 9/21/17.
//  Copyright © 2017 proxpero. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

}

