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
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.makeKeyAndVisible()
        
        DebugPanel.shared.startTrackNetwork()
        DebugPanel.shared.set(panelTable: .rootPanel)
        DebugPanel.shared.show()
        return true
    }
}

extension UIViewController {
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        DebugPanel.shared.show()
    }
}



public extension PanelTable {
    static var newsPanel: PanelTable {
        var pt = PanelTable("Новости")
        pt.addSection("Моки",
                      .labled(text: "list", onTap: nil),
                      .switcher(label: "list", onSwitch: { _ in }, valueProvider: .value(false), onTap: .handler({  })) )
        
        return pt
    }
    
    static var rootPanel: PanelTable {
        var pt = PanelTable("МойБрокер")
        pt.addSection("Модули",
                      .labled(text: "Новости", onTap: .showTable(newsPanel)),
                      .labled(text: "Котировки", onTap: .showTable(newsPanel)))
        
        return pt
    }
}
