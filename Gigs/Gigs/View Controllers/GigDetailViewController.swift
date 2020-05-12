//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Rob Vance on 5/11/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // Mark: IBOutlets
    @IBOutlet weak var titleOfGigTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var discriptionOfGigTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Mark: IBActions
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
