//
//  DynamicTableCell.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 15/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//


class DynamicTableCell: UITableViewCell  {
    class var identifier: String { return "cell" }
    weak var vc: UIViewController?
    
    var selectableAction:Action?
    
    private func push(_ vc: UIViewController) {
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSelectableAction() {
        handle(action: selectableAction)
    }
    
    func handle(action: Action?) {
        guard let action = action else { return }
        
        switch action {
        case .handler(let act): act()
        case .push(let vc): push(vc())
        case .showTable(let pt):
            let tableVC = DynamicTableVC(items: pt.sections)
            tableVC.navigationItem.title = pt.name
            push(tableVC)
        case let .showTextArea(valueProvider, handler):
            let vc = TextAreaVC.instantiate(text: valueProvider(), onSave: handler)
            push(vc)
        }
    }
}
