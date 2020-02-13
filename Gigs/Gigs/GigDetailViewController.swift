//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/13/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    
    
    // MARK: - Outlets
    
    @IBOutlet weak var gigNameTextField: UITextField!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Actions
    

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
