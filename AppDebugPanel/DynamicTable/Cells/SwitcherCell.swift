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
        let st = UIStackView(arrangedSubviews: [button, switcher])
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .equalCentering
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let switcher = UISwitch(frame: .zero)
    let button = UIButton(type: .custom)
 
    var onSwithed: Handler<Bool>!
    var switcherValueProvider: ValueProvider<Bool>! {
        didSet {
            switcher.isOn = switcherValueProvider.value
        }
    }
    
    var onTapped: Action? {
        didSet{ 
            button.isEnabled = onTapped != nil
            button.setTitleColor(button.isEnabled ? .blue: .black, for: .normal)
        }
    }
    
    var titleStr: String = "button" {
        didSet{
            button.setTitle(titleStr, for: .normal)
        }
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        onSwithed(sender.isOn)
    }

    @IBAction func action(_ sender: Any) {
        handle(action: onTapped)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapped =  nil
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle("button", for: .normal)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
 
