//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/12/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtvJobDescription: UITextView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    

    @IBAction func saveTapped(_ sender: Any) {
    }
    
    func updateViews() {
        if let gig = gig {
            txtJobTitle.text = gig.title
            datePicker.date = gig.dueDate
            txtvJobDescription.text = gig.description
            btnSave.isEnabled = false
            txtJobTitle.isEnabled = false
            datePicker.isEnabled = false
            txtvJobDescription.isEditable = false
        } else {
            title = "New Gig"
            btnSave.isEnabled = true
            txtJobTitle.isEnabled = true
            datePicker.isEnabled = true
            txtvJobDescription.isEditable = true
        }
    }
}
