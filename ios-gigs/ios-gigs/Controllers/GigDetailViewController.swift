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
    @IBOutlet weak var navBar: UINavigationItem!
    


    override func viewDidAppear(_ animated: Bool) {
        if detailGig != nil {
            saveButton.isEnabled = false
            navBar.title = "Gig Details"
            updateViews()
        } else {
            saveButton.isEnabled = true
            navBar.title = "New Gig"
        }
    }
    
    func updateViews() {
        guard let gig = detailGig else {return}
        DispatchQueue.main.async {
                       self.titleTextField.text = gig.title
                       self.datePicker.date = gig.dueDate
                       self.descriptionTextField.text = gig.description
                   }
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
