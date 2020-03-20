//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/19/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
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
