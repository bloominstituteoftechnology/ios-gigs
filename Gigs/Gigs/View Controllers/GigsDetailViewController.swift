//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/11/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveGig(_ sender: Any) {
    }
    
}
