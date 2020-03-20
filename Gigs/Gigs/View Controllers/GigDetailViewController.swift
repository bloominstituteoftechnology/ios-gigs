//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Elizabeth Thomas on 3/19/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    // MARK: - Private Properties
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let jobTitle = jobTitleTextField.text,
            let jobDescription = jobDescriptionTextView.text,
            !jobTitle.isEmpty,
            !jobDescription.isEmpty else { return }

        gig?.title = jobTitle
        gig?.decription = jobDescription
        gig?.dueDate = dueDatePicker.date
        
        let newGig = Gig(title: jobTitle, decription: jobDescription, dueDate: dueDatePicker.date)

        gigController.addGig(with: newGig) { _ in
            DispatchQueue.main.async {
                self.gig = newGig
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        dueDatePicker.datePickerMode = .date
    }
    
    // MARK: - Private methods
    private func updateViews() {
        guard let gig = gig else {
            self.title = "New Gig"
            return
        }
        self.title = gig.title
        jobTitleTextField.text = gig.title
        jobDescriptionTextView.text = gig.decription
        dueDatePicker.setDate(gig.dueDate, animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }


}
