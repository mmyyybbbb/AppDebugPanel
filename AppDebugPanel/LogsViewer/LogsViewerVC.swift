//
//  LogsViwer.swift
//  AppDebugPanel
//
//  Created by Andrey Raevnev on 05/09/2019.
//  Copyright © 2019 BCS. All rights reserved.
//
import UIKit

final class LogsViewerVC: UIViewController {

    @IBOutlet weak var toSlackButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!

    private var onSendToSlack: (() -> ())!

    static func instantiate(onSendToSlack: @escaping () -> ()) -> LogsViewerVC {
        let vc = UIStoryboard(name: "TextAreaVC", bundle: Bundle.init(for: LogsViewerVC.self)).instantiateViewController(withIdentifier: "LogsViewerVC") as! LogsViewerVC

        vc.onSendToSlack = onSendToSlack
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Логи"
        
        textView.text = DebugPanel.shared.currentLog
        let bottom = NSRange(location: textView.text.count - 1, length: 1)
        textView.scrollRangeToVisible(bottom)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        DebugPanel.shared.currentLog = ""
        textView.text = ""
    }
    
    @IBAction func sendLogToSlack(_ sender: Any) {
        onSendToSlack()
    }
    
}
