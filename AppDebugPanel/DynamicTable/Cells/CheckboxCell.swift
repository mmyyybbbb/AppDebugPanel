//
//  CheckboxCell.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 15/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

final class CheckboxCell: DynamicTableCell  {
    override class var identifier: String { return "Checkbox" }
    
    static let checkboxUpdateNotification = Notification.Name("checkboxUpdateNotification")
    
    static func notifyRefreshState() {
        NotificationCenter.default.post(name: checkboxUpdateNotification, object: nil)
    }
  
    var onCheck: (String) -> () = { _ in }
    var value: String = ""
    var checkedProvider: () -> Bool = { return false }
    
    @objc func refreshState() {
        let isCheked = checkedProvider()
         accessoryType = isCheked ? .checkmark : .none
    }

    func check() {
        onCheck(value)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshState), name: CheckboxCell.checkboxUpdateNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
