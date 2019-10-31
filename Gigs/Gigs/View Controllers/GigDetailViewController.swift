//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-31.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            titleField.text = gig.title
            descriptionView.text = gig.description
            dueDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }
}
