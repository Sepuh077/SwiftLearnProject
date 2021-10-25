//
//  db.swift
//  AnswerApp
//
//  Created by Sepuh on 06.10.21.
//

import Foundation
import UIKit
import CoreData


class Database {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let managedContext: NSManagedObjectContext!
    
    init() {
        managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func addUser(username: String, password: String) {
        let user = User(context: managedContext)
        user.level = 1
        user.username = username
        user.password = password
        user.id = Int16(getAllFromCoreData(tableName: "User").count)
        
        do {
            try managedContext.save()
        } catch _ { }
    }
    
    func addQuestionCoreData(question: String, rightAnswer: String, allAnswers: Array<String>) {

        let questionObj = Question(context: managedContext)
        questionObj.id = Int16(getAllFromCoreData(tableName: "Question").count)
        questionObj.question = question
        questionObj.right_answer = rightAnswer
        
        var wrongAnswers: String = ""
        
        for answer in allAnswers {
            if answer != rightAnswer {
                wrongAnswers.append(contentsOf: answer + "|")
            }
        }
        
        questionObj.wrong_answers = wrongAnswers
        
        do {
            try managedContext.save()
        } catch _ { }
    }

    func getAllFromCoreData(tableName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)

        do {
            let all = try managedContext.fetch(fetchRequest)
            
            return all
        } catch _ { }
        
        return []
    }
    
    func getUserById(userId: String) -> NSManagedObject? {
        let id = Int16(userId)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id!))
        
        do {
            let all = try managedContext.fetch(fetchRequest)

            if all.count > 0 {
                return all[0]
            }
        } catch _ { }
        
        return nil
    }
    
    func isUsernameExists(username: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        do {
            let all = try managedContext.fetch(fetchRequest)

            if all.count > 0 {
                return true
            }
        } catch _ { }
        
        return false
    }
    
    func getQuestionById(questionId: Int16) -> NSManagedObject? {
        let id = questionId
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Question")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do {
            let all = try managedContext.fetch(fetchRequest)

            if all.count > 0 {
                return all[0]
            }
        } catch _ { }
        
        return nil
    }
    
    func getUserByInfo(username: String, password: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        do {
            let all = try managedContext.fetch(fetchRequest)
            
            for el in all {
                if el.value(forKey: "password") as! String == password {
                    return el
                }
            }
        } catch _ { }
        
        return nil
    }

    func updateUser(id: Int16, level: Int16) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))

        do {
            let all = try managedContext.fetch(fetchRequest)

            for el in all {
                el.setValue(level, forKey: "level")
            }

            try managedContext.save()
        } catch _ { }
    }

//    func removeElementFromCoreData(isoCode: String) {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryTable")
//
//        fetchRequest.predicate = NSPredicate(format: "isoCode = %@", isoCode)
//
//        do {
//            let all = try managedContext.fetch(fetchRequest)
//
//            for el in all {
//                managedContext.delete(el)
//            }
//        } catch _ { }
//    }

    func deleteAllFromCoreData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Question")
        
        do {
            let all = try managedContext.fetch(fetchRequest)
            
            for el in all {
                managedContext.delete(el)
            }
        } catch _ { }
    }
}
