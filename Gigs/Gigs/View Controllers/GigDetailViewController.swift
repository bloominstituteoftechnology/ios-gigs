//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Thomas Cacciatore on 5/16/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        if let gig = gig {
            detailTextField.text = gig.title
            detailTextView.text = gig.description
            datePicker.date = gig.dueDate
        } else {
            navigationItem.title = "New Gig"
        }
        
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let gigName = detailTextView.text, !gigName.isEmpty,
            let gigDescription = detailTextView.text, !gigDescription.isEmpty,
        let gigDate = datePicker?.date else { return }
        gigController.createGig(title: gigName, descpription: gigDescription, dueDate: gigDate) { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var detailTextView: UITextView!
    var gigController: GigController!
    var gig: Gig?
    
}
