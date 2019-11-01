//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Rick Wolter on 10/31/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
