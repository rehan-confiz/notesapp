//
//  NoteViewController.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detail: UITextView!
    
    public var titleNote: String = ""
    public var detailNote: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleNote
        detail.text = detailNote
    }
    
}
