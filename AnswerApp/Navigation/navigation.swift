//
//  navigation.swift
//  AnswerApp
//
//  Created by Sepuh on 14.10.21.
//

import Foundation
import UIKit


class SidebarViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
        label.text = "aa"
        label.textColor = .black
        
        cell.addSubview(label)
        
        return cell
    }
}
