//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/12/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properites

    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Actions

    @IBAction func saveButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
