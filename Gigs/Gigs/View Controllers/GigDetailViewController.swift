//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by David Williams on 3/19/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func updateViews(with gig: Gig) {
        title = gig.title
        jobTitleTextField.text = gig.title
        
        jobDescriptionTextView.text = gig.description
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveJobTapped(_ sender: Any) {
    }
}
