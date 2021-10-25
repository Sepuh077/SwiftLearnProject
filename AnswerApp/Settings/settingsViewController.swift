//
//  settingsViewController.swift
//  AnswerApp
//
//  Created by Sepuh on 15.10.21.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController {
    var mainView: ViewController?
    private var subviewsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "backgroundMode") {
            self.view.backgroundColor = .black
        }
        else {
            self.view.backgroundColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            switch allSettings[indexPath.row].type {
            case .backgroundMode:
                return 40
            case .Test:
                break
            case .logout:
                break
            }
            
            return 150
        }
        else {
            switch allSettings[indexPath.row].type {
            case .backgroundMode:
                break
            case .Test:
                break
            case .logout:
                break
            }
            
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSettings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingViewCell
        cell.settingTitle.text = "    " + allSettings[indexPath.row].title
        
        settingBackgroundCheck(cell: cell)
        
        cell.cellButton.setTitle("", for: .normal)
        
        cell.config {
            if self.selectedIndexPath != indexPath {
                self.selectedIndexPath = indexPath
            }
            else {
                self.selectedIndexPath = IndexPath(index: -1)
            }
        }
        
        if subviewsAdded {
            return cell
        }
        
        switch allSettings[indexPath.row].type {
        case .backgroundMode:
            cell.settingDescription.text =   ""
            let backgroundModeSwitch = UISwitch()
            cell.addSubview(backgroundModeSwitch)
            
            backgroundModeSwitch.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = backgroundModeSwitch.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10)
            let verticalConstraint = backgroundModeSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
            
            backgroundModeSwitch.isOn = UserDefaults.standard.bool(forKey: "backgroundMode")

            backgroundModeSwitch.addTarget(self, action: #selector(backgroundModeSwitchTouched(_:)), for: .valueChanged)

        case .Test:
            cell.settingDescription.text = "Hello!!!"
            
        case .logout:
            cell.settingDescription.text = ""
            let logoutButton = UIButton()
            
            cell.addSubview(logoutButton)
            logoutButton.setTitle("Log Out", for: .normal)
            
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                logoutButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                logoutButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 70),
                logoutButton.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.2),
//                logoutButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.02),
            ]
            NSLayoutConstraint.activate(constraints)
            
            logoutButton.backgroundColor = .blue
            
            logoutButton.addTarget(self, action: #selector(logoutButtonEvent), for: .touchDown)
        }
        
        if indexPath.row == allSettings.count - 1 {
            subviewsAdded = true
        }
        
        return cell
    }
    
    @objc func logoutButtonEvent() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "authentication", bundle: nil)
        let loginView = storyBoard.instantiateViewController(withIdentifier: "1") as! LoginViewController
        loginView.modalPresentationStyle = .fullScreen
        self.present(loginView, animated: true, completion: nil)
    }

    func settingBackgroundCheck(cell: SettingViewCell) {
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2
        if UserDefaults.standard.bool(forKey: "backgroundMode") {
            cell.backgroundColor = .black
        }
        else {
            cell.backgroundColor = .white
        }
        cell.layer.borderColor = UIColor.brown.cgColor
    }
    
    internal var selectedIndexPath: IndexPath? {
        didSet {
            UIView.animate(withDuration: 0.35, animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }
    }
//    @IBAction func BackButtonClicked(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainView = storyBoard.instantiateViewController(withIdentifier: "1") as! ViewController
//        mainView.modalPresentationStyle = .fullScreen
//        self.present(mainView, animated: false, completion: nil)
//    }
    
    @objc func backgroundModeSwitchTouched(_ sender: UISwitch!) {
        let defaults = UserDefaults.standard
        
        defaults.set(sender.isOn, forKey: "backgroundMode")
        
        if sender.isOn == true {
            self.view.backgroundColor = .black
        }
        else {
            self.view.backgroundColor = .white
        }

        mainView!.checkBackgroundColor()
//        self.tableView.reloadData()
        
        var indexPaths: [IndexPath] = []
        for i in 0..<allSettings.count {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        self.tableView.reconfigureRows(at: indexPaths)
    }
}
