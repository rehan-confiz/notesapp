//
//  Note.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import Foundation
class Note{
    var note: String = ""
    var desc: String = ""
    var id: Int = 0
    
    init(note:String, desc:String)
    {
        self.note = note
        self.desc = desc
    }
    
    init(id: Int, note:String, desc:String)
    {
        self.note = note
        self.desc = desc
        self.id = id
    }
    
    
}
