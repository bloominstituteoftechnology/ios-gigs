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
            navigationController?.title = "Gig Details"
        } else {
            saveButton.isEnabled = true
            navigationController?.title = "New Gig"
        }
    }
    
    func updateViews() {
        guard let date = detailGig?.dueDate else {return}
        titleTextField.text = detailGig?.title
        datePicker.date = date
        descriptionTextField.text = detailGig?.description
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        detailGig?.title = titleTextField.text ?? "blank"
        detailGig?.dueDate = datePicker.date
        detailGig?.description = descriptionTextField.text
        guard let newGig = detailGig else {return}
        
        gigController.addGig(newGig, completion: { result in
            switch result {
                case .success(let newGig): print("New Gig has been added")
                case .failure(let error): print("There was an error: \(error)")
            }
            
        })
        self.navigationController?.popViewController(animated: true)
        
    }
}
