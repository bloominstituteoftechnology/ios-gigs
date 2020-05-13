//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by David Williams on 3/19/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            guard let gig = gig else { return }
            updateViews(with: gig)
        }
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let gig = gig else { return }
        
        guard let dueDate = dateFormatter.date(from: gig.dueDate) else { return }
        
        datePicker.setDate(dueDate, animated: true)
        
    }
    
    func updateViews(with gig: Gig) {
        title = gig.title
        jobTitleTextField.text = gig.title

      guard let dueDate = dateFormatter.date(from: gig.dueDate) else { return }
        
        datePicker.setDate(dueDate, animated: true)
        jobDescriptionTextView.text = gig.description
    }
    
    @IBAction func saveJobTapped(_ sender: Any) {
        let date = datePicker.date
        guard let jobTitle = jobTitleTextField.text,
            let description = jobDescriptionTextView.text,
            !jobTitle.isEmpty,
            !description.isEmpty else { return }
        
        gigController.createGig(with: jobTitle, date: date, description: description) { (result) in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

