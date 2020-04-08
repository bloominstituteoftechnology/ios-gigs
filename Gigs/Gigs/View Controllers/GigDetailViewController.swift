//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/8/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //Outlets
    @IBOutlet weak var jobTitleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
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
