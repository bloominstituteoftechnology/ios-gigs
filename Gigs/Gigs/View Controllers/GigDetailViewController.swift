//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_259 on 3/12/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - IBOutlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
