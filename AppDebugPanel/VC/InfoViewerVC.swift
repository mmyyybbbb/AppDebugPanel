//
//  InfoViewerVC.swift
//  AppDebugPanel
//
//  Created by Алексей Ненастьев on 09.03.2020.
//  Copyright © 2020 BCS. All rights reserved.
//

import UIKit
 
final class InfoViewerVC: UIViewController {

    @IBOutlet weak var toSlackButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!

    private var onSendToSlack: (() -> ())!

    var text: String = ""
    static func instantiate(onSendToSlack: @escaping () -> (), text: String) -> InfoViewerVC {
        let vc = UIStoryboard(name: "TextAreaVC", bundle: Bundle.init(for: LogsViewerVC.self)).instantiateViewController(withIdentifier: "InfoViewerVC") as! InfoViewerVC
        vc.text = text
        vc.onSendToSlack = onSendToSlack
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Инфо"
        
        textView.text = text
        let bottom = NSRange(location: textView.text.count - 1, length: 1)
        textView.scrollRangeToVisible(bottom)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyAction(_ sender: UIBarButtonItem) {
        UIPasteboard.general.string = textView.text
    }
    
    @IBAction func sendLogToSlack(_ sender: Any) {
        onSendToSlack()
    }
    
}
