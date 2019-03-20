//
//  DynamicTableRow.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 12/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

public typealias Handler<T> = (T) -> Void
public typealias CompletionHandler = () -> Void

public enum Action {
    case handler( ()->() )
    case push(() -> UIViewController)
    case showTable(PanelTable)
    case showTextArea(valueProvider: ()->String, handler: Handler<String>)
}

public enum ValueProvider<T> {
    case value(T)
    case provider( ()->T )
    
    var value: T {
        switch self {
        case .value(let val): return val
        case .provider(let prov): return prov()
        }
    }
}

public enum TableCellType {
    case switcher(label: String, subtext: String?, onSwitch: Handler<Bool>, valueProvider: ValueProvider<Bool>, onTap: Action?)
    case labled(text: String, onTap: Action?)
    case checkbox(text: String, value: String, checkedProvider: () -> Bool, action: (String) -> ())
    case action(title: String, onAction: Handler<CompletionHandler>, statusProvider: () -> String)
}


import UIKit

extension TableCellType {
    
    var cellIdentifier: String {
        switch self {
        case .switcher: return SwitcherCell.identifier
        case .labled: return DynamicTableCell.identifier
        case .checkbox: return CheckboxCell.identifier
        case .action: return ActionTableCell.identifier
        }
    }
    
    
    func dequeSetup(vc: UITableViewController) -> DynamicTableCell {
        
        guard  let cell = vc.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DynamicTableCell else {
            return DynamicTableCell()
        } 
        cell.vc = vc 
        cell.selectionStyle = .none
        
        func setup<T:UITableViewCell>(_ set: (T)-> Void) {
            guard let cell = cell as? T else { return }
            set(cell)
        }
        
        
        switch self {
        case let .switcher(text, subtext, onSwitch, value, onTap): setup { (cell: SwitcherCell) in
                cell.set(title: text, subtitle:subtext, onTapped: onTap, onSwitched: onSwitch, valueProvider: value)
            }
        case let .labled(text, onTap ): setup { (cell: DynamicTableCell) in
                cell.textLabel?.text = text
                cell.accessoryType = .disclosureIndicator
                cell.selectableAction = onTap
            }
        case let .checkbox(text, value, checkedProvider, action): setup { (cell: CheckboxCell) in
                cell.textLabel?.text = text
                cell.checkedProvider = checkedProvider
                cell.value = value 
                cell.onCheck = action
                cell.refreshState()
            }
        case let .action(title, onAction, statusProvider):
            let cell = cell as! ActionTableCell
            cell.set(action: onAction, actionTitle: title, stateProvider: statusProvider)
            
        }
        
        return cell
    }
}
