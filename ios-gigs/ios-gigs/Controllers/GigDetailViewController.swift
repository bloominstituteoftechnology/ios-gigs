//
//  GigDetailViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/12/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
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
        guard let gig = detailGig else {return}
        titleTextField.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextField.text = gig.description
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let controller = gigController,
            let title = titleTextField.text,
            !title.isEmpty,
            let description = descriptionTextField.text,
            !description.isEmpty else {return}
//        let dueDate = datePicker.date
        let newGig = Gig(title: title, dueDate: datePicker.date, description: description)
        
        controller.addGig(newGig, completion: { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
