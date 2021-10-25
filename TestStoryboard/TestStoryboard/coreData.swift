//
//  coreData.swift
//  TestStoryboard
//
//  Created by Sepuh on 13.09.21.
//

import Foundation
import UIKit
import CoreData


func addElementCoreData(id: Int32, isoCode: String, name: String, imageName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext

    let country = CountryTable(context: managedContext)
    
    country.id = id
    country.isoCode = isoCode
    country.name = name
    country.imageName = imageName
    
    do {
        try managedContext.save()
    } catch _ { }
}


func getAllFromCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")

    do {
        let all = try managedContext.fetch(fetchRequest)
        if all.count == 0 || countries.count > 0 {
            return
        }
        for _ in 1...all.count {
            countries.append(Country(isoCode: "1", name: "2", imageName: "3"))
        }
        for el in all {
            let i = el.value(forKey: "id") as! Int
            if el.value(forKey: "isoCode") == nil {
                continue
            }
            countries[i].isoCode = el.value(forKey: "isoCode") as! String
            countries[i].name = el.value(forKey: "name") as! String
            countries[i].imageName = el.value(forKey: "imageName") as! String
        }
    } catch _ { }
}

func getAllCountries() -> [Country] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return []
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")

    var countyList = [Country]()
    do {
        let allCounties = try managedContext.fetch(fetchRequest)
        let sorted = allCounties.sorted { first, second in
            (first.value(forKey: "id") as! Int) < (second.value(forKey: "id") as! Int)
        }
        for country in sorted {
            let isoCode = country.value(forKey: "isoCode") as! String
            let name = country.value(forKey: "name") as! String
            let imageName = country.value(forKey: "imageName") as! String
            countyList.append(Country(isoCode: isoCode, name: name, imageName: imageName))
        }
    } catch {
        debugPrint("Couldn't get countries list")
    }
    
    return countyList
}

func updateElementInCoreData(isoCode: String, newId: Int32, newImageName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")
    
    fetchRequest.predicate = NSPredicate(format: "isoCode = %@", isoCode)
    
    do {
        let all = try managedContext.fetch(fetchRequest)

        for el in all {
            el.setValue(newId, forKey: "id")
            el.setValue(newImageName, forKey: "imageName")
        }
        
        try managedContext.save()
    } catch _ { }
}


func removeElementFromCoreData(isoCode: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")
    
    fetchRequest.predicate = NSPredicate(format: "isoCode = %@", isoCode)
    
    do {
        let all = try managedContext.fetch(fetchRequest)
        
        for el in all {
            managedContext.delete(el)
        }
    } catch _ { }
}


func deleteAllFromCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")
    
    do {
        let all = try managedContext.fetch(fetchRequest)
        
        for el in all {
            managedContext.delete(el)
        }
    } catch _ { }
}


func insertRowsInCoreData() {
    deleteAllFromCoreData()
    
    var i: Int32 = 0
    for country in countries {
        addElementCoreData(id: i, isoCode: country.isoCode, name: country.name, imageName: country.imageName)
        i += 1
    }
}


func updateAllIdCoreData() {
    var i = Int32(0)
    for country in countries {
        updateElementInCoreData(isoCode: country.isoCode, newId: i, newImageName: country.imageName)
        i += 1
    }
}
