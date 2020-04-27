//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/11/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    var gigController: GigController?
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func saveGig(_ sender: Any) {
       
        guard //let gigController = gigController,
            let jobTitle = jobTitleTextField.text, !jobTitle.isEmpty,
            let description = descriptionTextView.text, !description.isEmpty else { return }
        
        let date = datePicker.date
        
        let newGig = Gig(title: jobTitle, description: description, dueDate: date)
        
        gigController?.createGig(for: newGig) { (error) in
            DispatchQueue.main.async {
                print("New gig created!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateViews() {
        if let gig = gig {
            title = "\(gig.title)"
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
}
