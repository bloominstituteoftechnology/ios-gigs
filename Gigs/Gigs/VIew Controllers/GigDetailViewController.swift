//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jarren Campos on 3/19/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var gigTitleTextField: UITextField!
    @IBOutlet var gigDueDatePicker: UIDatePicker!
    @IBOutlet var gigDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    


}
