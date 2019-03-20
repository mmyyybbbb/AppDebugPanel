//
//  ActionCell.swift
//  AppDebugPanel
//
//  Created by alexej_ne on 19/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//
import UIKit

final class ActionTableCell: DynamicTableCell  {
    override class var identifier: String { return "ActionCell" }

    let switcher = UISwitch(frame: .zero)

    lazy var button: UIButton = {
        let bt = UIButton(type: .system) 
        return bt
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        return av
    }()
    
    lazy var stateLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()

    lazy var stack: UIStackView = {
        let butStack = UIStackView(arrangedSubviews: [button, activityIndicator])
        butStack.axis = .horizontal
        butStack.alignment = .fill
        butStack.translatesAutoresizingMaskIntoConstraints = false
        
        let st = UIStackView(arrangedSubviews: [button, activityIndicator,  stateLabel])
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .equalCentering
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()

    func set(action: @escaping Handler<CompletionHandler>, actionTitle: String, stateProvider:  @escaping () -> String) {

        self.onAction = action
        self.button.setTitle(actionTitle, for: .normal)
        self.stateProvider = stateProvider

        inProgress = false
        refreshState()
    }
    
    private var inProgress: Bool = false {
        didSet{
            button.isHidden = inProgress
            stateLabel.isHidden = inProgress
            activityIndicator.isHidden = !inProgress
            
            if inProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func refreshState() {
        stateLabel.text = stateProvider()
    }

    private var onAction: Handler<CompletionHandler> = { _ in }
    private var stateProvider: () -> String = { return "" }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    @objc func doAction() {
        inProgress = true
        onAction(onActionDidEnd)
    }
    
    private func onActionDidEnd() {
        DispatchQueue.main.async {
            self.inProgress = false
            self.refreshState()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
            ])
        
        button.addTarget(self, action: #selector(doAction), for: .touchDown)
    }
}
