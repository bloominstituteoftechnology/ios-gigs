//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_259 on 3/12/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properties
    var gig: Gig?
    var gigController: GigController?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - IBOutlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        if gig != nil {
            navigationController?.popToRootViewController(animated: true)
        } else if let title = titleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty {
            let date = dueDatePicker.date
            gigController?.createGig(title: title, date: date, description: description)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gig = gig {
            titleTextField.text = gig.title
            titleTextField.isEnabled = false
            titleTextField.textAlignment = .center
            descriptionTextView.text = gig.description
            //descriptionTextView.isEditable = false
            
            dueDatePicker.datePickerMode = .dateAndTime
            //let date = dateFormatter.string(from: gig.dueDate)
            dueDatePicker.date = gig.dueDate
            dueDatePicker.isEnabled = false
        } else {
            title = "New Gig"
        }
    }
}
