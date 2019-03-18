//
//  DynamicTableVC.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 12/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

public struct TableSection {
    let items: [TableCellType]
    let name: String?
    
    public init(name: String, items: [TableCellType]) {
        self.name = name
        self.items  = items 
    }
}

final class DynamicTableVC: UITableViewController {
    
    private var sections: [TableSection] = []
  
    public init(items: [TableSection]) {
        self.sections = items
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44 
        
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.identifier)
        tableView.register(DynamicTableCell.self, forCellReuseIdentifier: DynamicTableCell.identifier)
        tableView.register(SwitcherCell.self, forCellReuseIdentifier: SwitcherCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        return sections[indexPath.section].items[indexPath.row].dequeSetup(vc: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelectableActionIfNeed(indexPath: indexPath)
        handleCheckboxActionIfNeed(indexPath: indexPath) 
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    private func item(for indexPath: IndexPath) -> TableCellType {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    private func handleSelectableActionIfNeed(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DynamicTableCell,  cell.selectableAction != nil   else { return }
        cell.handleSelectableAction()
    }
    
    private func handleCheckboxActionIfNeed(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CheckboxCell  else { return }
        cell.check()
        CheckboxCell.notifyRefreshState()
    }
    
}
