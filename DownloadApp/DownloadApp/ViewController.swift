//
//  ViewController.swift
//  DownloadApp
//
//  Created by Sepuh on 20.09.21.
//

import UIKit


func boldTextPart(firstPart: String, boldPart: String, lastPart: String) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: firstPart + boldPart + lastPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
    let range = NSRange(location: firstPart.count, length: boldPart.count)
    attributedString.addAttributes(boldFontAttribute, range: range)
    
    return attributedString
}


func removeSpacesFromString(_ text: String) -> String {
    let text = text.components(separatedBy: .whitespaces).joined()
    
    return text
}


class ViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var notification: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func showButtonClicked(_ sender: Any) {
        let text: String = removeSpacesFromString(urlInput.text!)
        
        urlInput.text = Optional("")
        
        if text == Optional("") {
            showNotification("Fill input field!")
            return
        }
        let message = boldTextPart(firstPart: "Do you want to open\n", boldPart: text, lastPart: "\nlink?")
        
        let alert = UIAlertController(title: "Ask", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.setValue(message, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            guard let url = URL(string: text) else { return }
            if !UIApplication.shared.canOpenURL(url) {
                self.showNotification("Wrong URL!")
                return
            }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func showNotification(_ text: String) {
        notificationLabel.text = Optional(text)
        notification.isHidden = false
    }
    
    @IBAction func notCloseButtonClicked(_ sender: Any) {
        notification.isHidden = true
    }
}
