//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/12/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var jobTitleTextField: UITextField!
    
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
