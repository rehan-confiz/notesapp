//
//  ViewController.swift
//  notesapp
//
//  Created by Confiz on 10/21/20.
//  Copyright © 2020 Confiz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //init views
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    //model array declared
    var models: [(note: String, desc: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "Notes"
    }
    
    @IBAction func didTapNewNote(){
       guard let vc = storyboard?.instantiateViewController(identifier: "new") as?NewNoteViewController else {
            return
        }
        vc.complition = {noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            self.models.append((note: noteTitle, desc: note))
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        vc.title = "New Note"
                vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated:true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].note
        cell.detailTextLabel?.text = models[indexPath.row].desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as?NoteViewController else {
            return
        }
        let model = models[indexPath.row]
        vc.titleNote = model.note
        vc.detailNote = model.desc
        vc.title = "Notes"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated:true)
    }


}

