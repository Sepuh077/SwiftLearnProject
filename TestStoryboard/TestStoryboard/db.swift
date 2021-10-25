//
//  db.swift
//  TestStoryboard
//
//  Created by Sepuh Hovhannisyan on 31.08.21.
//

import Foundation
import SQLite3

let CREATE_TABLE = "CREATE TABLE Country(Id INT, IsoCode CHAR(255) UNIQUE, Name CHAR(255), ImageName CHAR(255));"
let queryStatementString = "SELECT * FROM Country ORDER BY Id;"
let deleteStatementString = "DELETE FROM Country"
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)


class DataBase {
    private var db: OpaquePointer?
    
    init() {
        let db_path:Optional = projectPath + "db.sqlite3"
        guard let part1DbPath = db_path else {
            print("part1DbPath is nil.")
            db = nil
            return
        }
        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
        } else {
            print("Unable to open database.")
            db = nil
        }
    }
    
    func createTable() {
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, CREATE_TABLE, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nContact table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert() {
        var i: Int32 = 0
        for country in countries {
            insert_element(countryIndex: i, countryIsoCode: country.isoCode, countryName: country.name, imageName: country.imageName)
            i += 1
        }
    }
    
    func insert_element(countryIndex: Int32, countryIsoCode: String, countryName: String, imageName: String) {
        let insertString = "INSERT INTO Country (Id, IsoCode, Name, ImageName) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, countryIndex)
            
            sqlite3_bind_text(insertStatement, 2, countryIsoCode, -1, SQLITE_TRANSIENT)
            
            sqlite3_bind_text(insertStatement, 3, countryName, -1, SQLITE_TRANSIENT)
            
            sqlite3_bind_text(insertStatement, 4, imageName, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func query() {
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let isoCode = String(cString: sqlite3_column_text(queryStatement, 1))
                
                let name = String(cString: sqlite3_column_text(queryStatement, 2))
                
                let imageName = String(cString: sqlite3_column_text(queryStatement, 3))
                
                for country in countries {
                    if country.isoCode == isoCode {
                        return
                    }
                }
                countries.append(Country(isoCode: isoCode, name: name, imageName: imageName))
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func delete() {
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }

        sqlite3_finalize(deleteStatement)
    }
    
    func delete_row(isoCode: String) {
        var deleteStatement: OpaquePointer?
        let deleteElementString = "DELETE FROM Country WHERE IsoCode==\"\(isoCode)\";"
        if sqlite3_prepare_v2(db, deleteElementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }

        sqlite3_finalize(deleteStatement)
    }
    
    func update_row(isoCode: String, id: Int32, imageName: String) {
        var updateStatement: OpaquePointer?
        let updateElementString = "UPDATE Country Set Id=\(id), ImageName=\"\(imageName)\" WHERE IsoCode==\"\(isoCode)\";"
        if sqlite3_prepare_v2(db, updateElementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_OK {
                print("\nUpdated")
            }
            else {
                print("\nCould not update row, where isoCode is \(isoCode)")
            }
        }
        
        sqlite3_finalize(updateStatement)
    }
}
