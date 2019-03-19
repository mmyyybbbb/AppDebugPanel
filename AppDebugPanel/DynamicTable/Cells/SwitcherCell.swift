//
//  LabelSwitcherCell.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 14/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

import UIKit

final class SwitcherCell: DynamicTableCell {

    override class var identifier: String  { return  "SwitcherCell" }
    
    lazy var stack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [label, switcher])
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .equalCentering
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let switcher = UISwitch(frame: .zero)
    let label = UILabel(frame: .zero)
 
    private var onSwithed: Handler<Bool>!
    private var switcherValueProvider: ValueProvider<Bool>! {
        didSet {
            switcher.isOn = switcherValueProvider.value
            switched()
        }
    } 
    private var onTapped: Action?
    
    @objc func switched() {
        onSwithed(switcher.isOn)
        selectableAction = switcher.isOn ? onTapped : nil
        self.accessoryType  = switcher.isOn && onTapped != nil ? .disclosureIndicator : .none
    }
 
    func set(title: String, onTapped: Action?, onSwitched: @escaping Handler<Bool>,  valueProvider: ValueProvider<Bool>) {
        
        self.label.text = title
        self.onSwithed = onSwitched
        self.switcherValueProvider = valueProvider
        self.onTapped = onTapped
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
            ])
        
        switcher.addTarget(self, action: #selector(switched), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
 
