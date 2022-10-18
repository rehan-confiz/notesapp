//
//  NewNoteViewController.swift
//  notesapp
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    //init views
    @IBOutlet public var noteTitle: UITextField!
    @IBOutlet public var noteDetail: UITextView!
    var noteId: Int = 0
    var noteTitleStr: String = ""
    var noteDescStr: String = ""
    public var complition: ((Note) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteDetail.delegate = self
        noteDetail.setBoarder()
        if(noteDescStr.count==0){
            noteDetail.setPlaceholder(label: "Enter the Note Detail...")
        }else{
              noteDetail.text = noteDescStr
            noteDetail.setPlaceholder(label: "")
        }
        noteTitle.text = noteTitleStr
        self.noteTitle.delegate = self
        title = "Add/Update Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          // Try to find next responder
          if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
             nextField.becomeFirstResponder()
          } else {
             // Not found, so remove keyboard.
             textField.resignFirstResponder()
          }
          // Do not add a line break
          return false
       }
   
    @objc func saveNote(){
        if let noteTitleValue = noteTitle.text{
            if noteTitleValue.count == 0 {
                self.showToast(message: "Please enter the Note Title")
                return
            }
        }
    
        if let noteDetailValue = noteDetail.text{
            if noteDetailValue.count == 0 {
                self.showToast(message: "Please enter the Note Detail")
                return
            }
        }
        
        if let note = noteTitle.text, !note.isEmpty{
            if let noteDetailValue = noteDetail.text{
            let noteObj = Note(id: noteId,note: note, desc: noteDetailValue)
            complition?(noteObj)
        }
        }
    }
}
