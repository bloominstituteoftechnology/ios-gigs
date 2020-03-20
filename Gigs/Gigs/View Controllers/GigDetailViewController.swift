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
        guard let gig = gig else { return }
        datePicker.setDate(gig.dueDate, animated: true)
        
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
        guard let jobTitle = jobTitleTextField.text,
            let date = datePicker.date,
            let description = jobDescriptionTextView.text,
            !jobTitle.isEmpty,
            !date.isEmpty,
            !description.isEmpty else { return }
        
        gigController.createGig(with: jobTitle, date: Date, description: description)
    }
}
