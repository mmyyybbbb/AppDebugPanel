//
//  PanelTable.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 18/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//


public struct PanelTable {
    public let name: String
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

extension PanelTable {
    public mutating func addStringCheckBoxGroup(groupName: String, action: @escaping (String) -> Void, currentValueProvider: @escaping () -> String, items: [String]) {
        
        let cells =  items.map { item -> TableCellType in
            let checkedProvider = { currentValueProvider() == item }
            return .checkbox(text: item, value: item, checkedProvider: checkedProvider, action: action)
        }
        let tableSection = TableSection(name: groupName, items: cells)
        self.add(tableSection)
    }
    
    public mutating func addSubPanels(groupName: String, panels: PanelTable...) {
        let cells = panels.map { item -> TableCellType in
            return  .labled(text: item.name, onTap: .showTable(item))
        }
        let tableSection = TableSection(name: groupName, items: cells)
        self.add(tableSection)
    }
}
