//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/7/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import os.log

class GigDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var gig: Gig?
    
    private func showDetailSetUp() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.setDate(gig.dueDate, animated: false)
            descriptionTextView.text = gig.description
            self.title = gig.title
        } else {
            self.title = "New Gig"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        jobTitleTextField.delegate = self

        showDetailSetUp()
    }
    
    private func setGig() {
        let jobTitle = jobTitleTextField.text ?? ""
        let jobDate = datePicker.date
        let jobDescription = descriptionTextView.text ?? ""
        
        gig = Gig(title: jobTitle, dueDate: jobDate, description: jobDescription)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        setGig()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = jobTitleTextField.text ?? ""
        
        if !text.isEmpty {
            saveButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        jobTitleTextField.resignFirstResponder()
        
        return true
    }

}
