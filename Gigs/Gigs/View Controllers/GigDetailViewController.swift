//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by John Kouris on 9/12/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController?
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
            descriptionTextView.text = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let titleText = jobTitleTextField.text,
            !titleText.isEmpty,
            let descriptionText = descriptionTextView.text,
            !descriptionText.isEmpty else {
                return
        }
        
        let gig = Gig(title: titleText, dueDate: datePicker.date, description: descriptionText)
        
        gigController?.createGig(with: gig, completion: { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
}
