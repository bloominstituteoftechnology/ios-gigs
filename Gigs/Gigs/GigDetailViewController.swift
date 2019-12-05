//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Zack Larsen on 12/5/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
  

}
