//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 16/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return
        }
        
        jobTextField.text = gig.title
        datePicker.date = gig.dueDate
        textView.text = gig.description
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let jobTitle = jobTextField.text,
            let jobDescription = textView.text else { return }
        
        let gig = Gig(title: jobTitle, dueDate: datePicker.date, description: jobDescription)
        
        gigController.create(gig: gig) { (result) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
