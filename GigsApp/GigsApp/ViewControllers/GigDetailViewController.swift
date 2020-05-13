//
//  GigDetailViewController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var gigDueDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTextField: UITextView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}
