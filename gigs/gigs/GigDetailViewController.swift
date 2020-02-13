//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/13/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    
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

    
    //MARK: Actions
    
    @IBAction func saveGigButton(_ sender: UIBarButtonItem) {
    }
    
}
