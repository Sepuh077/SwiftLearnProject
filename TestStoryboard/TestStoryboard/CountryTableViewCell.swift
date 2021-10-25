//
//  CountryTableViewCell.swift
//  TestStoryboard
//
//  Created by Sepuh Hovhannisyan on 31.08.21.
//

import UIKit


class CountryTableViewCell: UITableViewCell {
    @IBOutlet var countryTitleLabel: UILabel!
    @IBOutlet var countryTextLabel: UILabel!
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    
    public var lastUpdateDate: Date = Date()
    private var handleRemove: (()->Void)?
    private var handleInfo: (()->Void)?
    
    func config(removeHandler: @escaping ()->Void) {
        handleRemove = removeHandler
    }
    
    func config_info(clickHandler: @escaping ()->Void) {
        handleInfo = clickHandler
    }
    
    @IBAction func removeElement(_ sender: UIButton) {
        handleRemove?()
    }
    @IBAction func switchToInfo(_ sender: UIButton) {
        handleInfo?()
    }
}
