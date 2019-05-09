//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jeffrey Carpenter on 5/9/19.
//  Copyright © 2019 Jeffrey Carpenter. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    var gig: Gig?

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Listen for tap events
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        updateViews()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        guard gigDescriptionTextView.isFirstResponder else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        view.endEditing(true)
        
        guard let jobTitle = jobTitleTextField.text,
        !jobTitle.isEmpty,
        let description = gigDescriptionTextView.text,
        !description.isEmpty
        else { return }
        
        
        let dueDate = dueDatePicker.date
        
        let newGig = Gig(title: jobTitle, description: description, dueDate: dueDate)
        
        gigController?.createGig(with: newGig, completion: { error in
            
            if let error = error {
                NSLog("Error saving new gig: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.gig = newGig
                self.updateViews()
            }
        })
    }
    
    private func updateViews() {
        
        if let gig = gig {
            
            self.title = gig.title
            jobTitleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            gigDescriptionTextView.text = gig.description
            
            // Make UI Elements Non-editable
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            gigDescriptionTextView.isEditable = false
        } else {
            self.title = "New Gig"
            gigDescriptionTextView.text = "Enter description"
        }
    }
}
