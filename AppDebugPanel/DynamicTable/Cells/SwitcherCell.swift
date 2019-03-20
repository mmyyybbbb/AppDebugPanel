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
        let labelsStack = UIStackView(arrangedSubviews: [label, subLabel])
        labelsStack.axis = .vertical
        labelsStack.distribution = .fill
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let st = UIStackView(arrangedSubviews: [labelsStack, switcher])
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .equalCentering
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let switcher = UISwitch(frame: .zero)
    let label = UILabel(frame: .zero)
    let subLabel = UILabel(frame: .zero)
 

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
 
    func set(title: String, subtitle: String?, onTapped: Action?, onSwitched: @escaping Handler<Bool>,  valueProvider: ValueProvider<Bool>) {
        self.subLabel.text = subtitle
        self.subLabel.isHidden = subtitle == nil
        label.font = label.font.withSize(subtitle == nil ? 16 : 15)
        self.label.text = title
        self.onSwithed = onSwitched
        self.onTapped = onTapped
        self.switcherValueProvider = valueProvider
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stack)
        subLabel.lineBreakMode = .byTruncatingHead
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
 
