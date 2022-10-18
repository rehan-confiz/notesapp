//
//  DBHelper.swift
//  notesapp
//
//  Created by Confiz on 11/5/20.
//  Copyright © 2020 Confiz. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        self.db = openDatabase()
        self.createTable()
    }

    let dbPath: String = "notesApp.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathExtension(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS notes(Id INTEGER PRIMARY KEY AUTOINCREMENT,note TEXT,description TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("notes table created.")
            } else {
                print("notes table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(note:String, desc:String)
    {
    
        let insertStatementString = "INSERT INTO notes (id, note, description) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (note as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (desc as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Note] {
        let queryStatementString = "SELECT * FROM notes;"
        var queryStatement: OpaquePointer? = nil
        var notes : [Note] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let desc = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                notes.append(Note(id: Int(id), note: name, desc: desc))
                print("Query Result:")
                print("\(id) | \(name) | \(desc)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return notes
    }
    
    func update(note: Note) {
        let updateStatementString = "UPDATE notes SET note = '\(note.note)', description = '\(note.desc)' WHERE Id = \(note.id);"
      var updateStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
          print("\nSuccessfully updated row.")
        } else {
          print("\nCould not update row.")
        }
      } else {
        print("\nUPDATE statement is not prepared")
      }
      sqlite3_finalize(updateStatement)
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM notes WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
