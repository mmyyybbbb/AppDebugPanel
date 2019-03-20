//
//  Main.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 15/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

import UIKit
import netfox
public final class DebugPanel {
  
    public static let shared = DebugPanel()
    private var mainPanelTable: PanelTable?
    private var currentPresented: UIViewController?
    
    private init() {
        NFX.sharedInstance().setGesture(.custom)
    }
    
    public func startTrackNetwork() {
        NFX.sharedInstance().start()
    }
    
    public func set(panelTable: PanelTable) {
        self.mainPanelTable = panelTable
    }
    
    public func show() {
        guard let panel = mainPanelTable else { return }
        let vc = build(pt: panel)
        presentingViewController?.present(vc, animated: true, completion: nil)
        currentPresented = vc
    }
    
    @objc public func hide() {
        currentPresented?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate var presentingViewController: UIViewController? {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        while let controller = rootViewController?.presentedViewController {
            rootViewController = controller
        }
        return rootViewController
    }
    
    private func build(pt: PanelTable) -> UIViewController {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        
        let nav = UINavigationController()
        nav.isToolbarHidden = false
        nav.hidesBarsWhenKeyboardAppears = false
        nav.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = nav
        nav.interactivePopGestureRecognizer?.isEnabled = true
        
        let table = DynamicTableVC(items: pt.sections)
        table.navigationItem.title = "\(pt.name) \(version).\(build)"
        table.toolbarItems = [
            UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(hide)),
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Сеть", style: .done, target: self, action: #selector(openNetfox))
        ]
        nav.pushViewController(table, animated: false)
        return nav
    }
    
    
    @objc func openNetfox() {
        NFX.sharedInstance().show()
    }
    
    
}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


