//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Rob Vance on 5/11/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // Mark: IBOutlets
    @IBOutlet weak var titleOfGigTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var discriptionOfGigTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func updateViews(with newGig: Gig) {
        if gig == nil {
            self.title = "New Gig"
        } else {
            titleOfGigTextField.text = newGig.title
            datePicker.date = newGig.dueDate
            discriptionOfGigTextView.text = newGig.discription
        }
    }
    
    func getGig() {
        guard let gigController = gigController,
            let gig = self.gig else { return }
        
        gigController.fetchGigDetails(for: gig) { (result) in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: gig)
                }
            }
        }
    }
    
    // Mark: IBActions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let newGigTitle = titleOfGigTextField.text, !newGigTitle.isEmpty,
            let newGigDiscription = discriptionOfGigTextView.text, !newGigDiscription.isEmpty {
            let newGigDueDate = datePicker.date
        let newGig = Gig(title: newGigTitle, discription: newGigDiscription, dueDate: newGigDueDate)
            gigController.addGig(newGig: newGig) { (error) in
                if let error = error {
                    print("Error adding new gig: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
}
