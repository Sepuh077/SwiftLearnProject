//
//  CountriesTableViewController.swift
//  TestStoryboard
//
//  Created by Sepuh Hovhannisyan on 30.08.21.
//

import UIKit


struct Country {
    var isoCode: String
    var name: String
    var imageName: String
    
    init(isoCode: String, name: String, imageName: String) {
        self.isoCode = isoCode
        self.name = name
        self.imageName = imageName
    }
}

var projectPath: String = #file

//var countries = [
//    Country(isoCode: "at", name: "Austria", imageName: "at"),
//    Country(isoCode: "de", name: "Germany", imageName: "de"),
//    Country(isoCode: "fr", name: "France", imageName: "fr"),
//    Country(isoCode: "el", name: "Greece", imageName: "el"),
//]
var countries = Array<Country>()

//let db = DataBase()
//
//func createDBTable() {
//    db.createTable()
//    db.delete()
//    db.insert()
//    db.query()
//}


//func updateRowsDB() {
//    var i: Int32 = 0
//    for country in countries {
//        db.update_row(isoCode: country.isoCode, id: i, imageName: country.imageName)
//        i += 1
//    }
//}


func getNewImageName() -> String {
    while true {
        var uuidImage = UUID().uuidString
        do {
            uuidImage.removeLast(uuidImage.count - 10)
            let directoryList = try FileManager.default.contentsOfDirectory(atPath: projectPath + "Assets.xcassets")
            
            for var fileName in directoryList {
                if fileName.hasSuffix(".jpg") {
                    fileName.removeLast(4)
                    if fileName == uuidImage {
                        continue
                    }
                }
            }
            return uuidImage
        }
        catch _ { }
    }
}


class CountriesTableViewController: UITableViewController {
    // MARK: - Table view data source
    @IBOutlet weak var addButton: UIButton!
    @objc func buttonClicked(sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "input", bundle: nil)
        let nextView = storyBoard.instantiateViewController(identifier: "2") as! inputViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryTableViewCell

        let country = countries[indexPath.row]
        cell.countryTitleLabel?.text = country.isoCode
        cell.countryTextLabel?.text = country.name
        cell.countryImageView?.image = UIImage(named: projectPath + "Assets.xcassets/\(country.imageName).jpg")
        cell.config {
//            db.delete_row(isoCode: countries[indexPath.row].isoCode)
            removeElementFromCoreData(isoCode: countries[indexPath.row].isoCode)
            removeImage(path: projectPath + "Assets.xcassets/\(countries[indexPath.row].imageName).jpg")
            countries.remove(at: indexPath.row)
            self.tableView.reloadData()
//            updateRowsDB()
            updateAllIdCoreData()
//            guard let url = URL(string: "https://intranet.instigatemobile.com/") else {
//                return
//            }
//            UIApplication.shared.open(url)
        }
        cell.config_info {
            let storyBoard = UIStoryboard(name: "info", bundle: nil)
            let nextView = storyBoard.instantiateViewController(identifier: "3") as! countryInfoController
            self.present(nextView, animated: true, completion: nil)
            nextView.config(country: country, indexPath: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Countries"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        while projectPath.last != "/" {
            projectPath.removeLast()
        }
        
//        insertRowsInCoreData()
        countries = getAllCountries()
        updateElementInCoreData(isoCode: "at", newId: 2, newImageName: "asas")
//        createDBTable()
        addButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        self.tableView.isEditing = true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = countries[sourceIndexPath.row]
        countries.remove(at: sourceIndexPath.row)
        countries.insert(movedObject, at: destinationIndexPath.row)
//        updateRowsDB()
        updateAllIdCoreData()
        tableView.reloadData()
    }
}
