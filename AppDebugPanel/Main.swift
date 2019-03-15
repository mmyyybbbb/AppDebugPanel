//
//  Main.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 15/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

import UIKit

public final class DebugPanelBuilder {
 
    static var currentEndpoint: String = "https://my.broker.ru"

    
    public init() {}
    
    public func build(pt: PanelTable) -> UIViewController {
        let nav = UINavigationController()
        nav.isToolbarHidden = false
        nav.hidesBarsWhenKeyboardAppears = true
        nav.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = nav
        nav.interactivePopGestureRecognizer?.isEnabled = true
        
        let table = DynamicTableVC(items: pt.sections)
        table.navigationItem.title = pt.name
        nav.pushViewController(table, animated: false)
        return nav
    }
}
extension UINavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


public struct PanelTable {
    let name: String
    private(set) var sections: [TableSection]
    
    public init(_ name: String, sections: [TableSection] = []) {
        self.name = name
        self.sections = sections
    }
    
    public mutating  func add(_ section: TableSection) {
        sections.append(section)
    }
    
    public mutating  func addSection(_ name: String, _ items: TableCellType...) {
        add(TableSection(name: name, items: items))
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
        
        func checkbox(_ value: String) -> TableCellType {
           return .checkbox(text: value,
                            value: value,
                            checkedProvider: { return DebugPanelBuilder.currentEndpoint == value},
                            action: { val in DebugPanelBuilder.currentEndpoint = val})
        }
        
        pt.addSection("Сервер",
                      checkbox("https://my.broker.ru"),
                      checkbox("https://effectivetrade.ru"),
                      checkbox("https://my.broker.ru/test"))
        return pt
    }
    
    
}


