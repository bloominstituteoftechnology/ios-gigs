//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Ahava on 5/14/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if let gig = gig {
            dueDatePicker.date = gig.dueDate
            jobTitleTextField.text = gig.title
            jobDescriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    
    @IBAction func saveGig(_ sender: Any) {
        if let gig = gig,
            let title = jobTitleTextField.text,
            let description = jobDescriptionTextView.text {
            
            gigController.addGig(gig: Gig(title: title, description: description, dueDate: dueDatePicker.date)) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }

//                if let title = jobTitleTextField.text,
//                    let description = jobDescriptionTextView.text,
//                    let index = gigController.gigs.firstIndex(of: gig) {
//                    gigController.gigs[index].title = title
//                    gigController.gigs[index].description = description
//                    gigController.gigs[index].dueDate = dueDatePicker.date
//                }
            }
        }
    }
    
}
