//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Kenny on 1/16/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: IBActions
    @IBAction func saveButtonWasTapped(_ sender: Any) {
        guard let titleText = jobTitleTextField.text,
            titleText != "",
            let descriptionText = descriptionTextView.text,
            descriptionText != ""
        else {return}
        
        let localGig = Gig(title: titleText, dueDate: dueDatePicker.date, description: descriptionText)
        print(gigController)
        gigController?.createGig(gig: localGig) { error in
            if let error = error {
                print(error)
                return
            }
            print("gig \(localGig) was created")
        }
    }
    
    //MARK: Properties
    var gig: Gig? {
        didSet {
            title = gig?.title
        }
    }
    
    var gigController: GigController?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    //MARK: Helper Methods
    func updateViews() {
        if let gig = gig {
            saveButton.isEnabled = false
            //textField
            jobTitleTextField.text = gig.title
            jobTitleTextField.isEnabled = false
            //datePicker
            dueDatePicker.date = gig.dueDate
            dueDatePicker.isEnabled = false
            //textView
            descriptionTextView.text = gig.description
            descriptionTextView.isUserInteractionEnabled = false
        }
    }
    
}
