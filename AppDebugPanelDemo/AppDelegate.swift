//
//  AppDelegate.swift
//  AppDebugPanelDemo
//
//  Created by alexej_ne on 12/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

import UIKit
import AppDebugPanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = DebugPanelBuilder().build(pt: .rootPanel)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        return true 
    }
}

