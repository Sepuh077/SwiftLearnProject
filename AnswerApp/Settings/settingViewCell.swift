//
//  settingViewCell.swift
//  AnswerApp
//
//  Created by Sepuh on 15.10.21.
//

import Foundation
import UIKit


class SettingViewCell: UITableViewCell {
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingDescription: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    var clickHandler: (() -> Void)?
    
    func config(clicked: @escaping () -> Void) {
        clickHandler = clicked
    }
    @IBAction func cellClicked(_ sender: Any) {
        clickHandler?()
    }
}
