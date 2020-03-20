//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/19/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //MARK: -Properties and IBOutlets-
    
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    //MARK: -Methods and IBActions-
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    

} //End of class
