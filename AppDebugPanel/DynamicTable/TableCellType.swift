//
//  DynamicTableRow.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 12/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

public typealias Handler<T> = (T) -> Void

public enum Action {
    case handler( ()->() )
    case push(() -> UIViewController)
    case showTable(PanelTable)
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
    case switcher(label: String, onSwitch: Handler<Bool>, valueProvider: ValueProvider<Bool>, onTap: Action?)
    case labled(text: String, onTap: Action?)
    case checkbox(text: String, value: String, checkedProvider: () -> Bool, action: (String) -> ())
}


import UIKit

extension TableCellType {
    
    var cellIdentifier: String {
        switch self {
        case .switcher: return SwitcherCell.identifier
        case .labled: return DynamicTableCell.identifier
        case .checkbox: return CheckboxCell.identifier
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
        case let .switcher(text, onSwitch, value, onTap): setup { (cell: SwitcherCell) in
                cell.onTapped = onTap
                cell.onSwithed = onSwitch
                cell.switcherValueProvider = value
                cell.titleStr = text
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
        }
        
        return cell
    }
}
