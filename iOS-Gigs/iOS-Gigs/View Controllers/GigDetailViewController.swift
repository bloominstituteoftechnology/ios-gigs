//
//  GigDetailViewController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/3/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobLTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        guard let gig = gig, isViewLoaded else {
            title = "New Gig"
            return
        }
        
        jobLTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
    }
    
    @IBAction func saveButtonTabbed(_ sender: UIBarButtonItem) {
        guard let job = jobLTextField.text, !job.isEmpty,
            let description = descriptionTextView.text, !description.isEmpty else {
            return
        }
        
        let newGig = Gig(title: job, description: description, dueDate: dueDatePicker.date)
        gigController.createNewGig(with: newGig) { (result) in
            do {
                try result.get()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                NSLog("Error saving gig: \(error)")
            }
        }
        
    }
            
        
}
