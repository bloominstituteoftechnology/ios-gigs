//
//  GigDetailViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/12/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var detailGig: Gig?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    


    override func viewWillAppear(_ animated: Bool) {
        if detailGig != nil {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func updateViews() {
        guard let date = detailGig?.dueDate else {return}
        titleTextField.text = detailGig?.title
        datePicker.date = date
        descriptionTextField.text = detailGig?.description
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        var inout myGig: Gig?
        myGig?.title = titleTextField.text
        gig?.dueDate = datePicker.date
        gig?.description = descriptionTextField.text
        gigController.addGig(gig) { (error) in
        if let error = error {
            print("Add Error: \(error)")
        } else {
            self.dismiss(animated: true)
                }
            }
        }
  
}
