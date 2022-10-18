//
//  MainViewController.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    //init views
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var db:DBHelper = DBHelper()
    
    //model array declared
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

        table.delegate = self
        table.dataSource = self
        title = "Notes"
        notes = db.read()
        if(notes.count == 0){
            self.label.isHidden = false
                       self.table.isHidden = true
        }
    }
    
    @IBAction func logout(){
        UserDefaults.standard.set(false, forKey: "isLogin")
        guard let vc = self.storyboard?.instantiateViewController(identifier: "login") as?LoginViewController else {
                       return
                   }
                      vc.navigationItem.largeTitleDisplayMode = .never
                   self.navigationController?.pushViewController(vc, animated:true)
                    var navigationArray = self.navigationController?.viewControllers // To get all UIViewController stack as Array
                    navigationArray?.remove(at: 0) // To remove previous UIViewController
                    self.navigationController?.viewControllers.remove(at: 0)
    }
    
    @IBAction func didTapNewNote(){
       guard let vc = storyboard?.instantiateViewController(identifier: "new") as?NewNoteViewController else {
            return
        }
        vc.complition = {noteObj in
            if(noteObj.id == 0){
                self.db.insert(note: noteObj.note, desc: noteObj.desc)
            }else{
                self.db.update(note: noteObj)
            }
            self.notes = self.db.read()
            self.navigationController?.popToRootViewController(animated: true)
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        vc.title = "New Note"
                vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated:true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].note
        cell.detailTextLabel?.text = notes[indexPath.row].desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.db.deleteByID(id: notes[indexPath.row].id)
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
              guard let vc = storyboard?.instantiateViewController(identifier: "new") as?NewNoteViewController else {
                  return
              }
              let model = self.notes[indexPath.row]
              vc.noteTitleStr = model.note
              vc.noteDescStr = model.desc
              vc.noteId = model.id
              vc.complition = {noteObj in
                        if(noteObj.id == 0){
                            self.db.insert(note: noteObj.note, desc: noteObj.desc)
                        }else{
                            self.db.update(note: noteObj)
                        }
                        self.notes = self.db.read()
                        self.navigationController?.popToRootViewController(animated: true)
                        self.label.isHidden = true
                        self.table.isHidden = false
                        self.table.reloadData()
                    }
              vc.title = "Notes"
              vc.navigationItem.largeTitleDisplayMode = .never
              navigationController?.pushViewController(vc, animated:true)
       }

}
