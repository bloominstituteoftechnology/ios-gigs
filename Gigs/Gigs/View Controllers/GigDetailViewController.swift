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
    
    var gigController = GigController()
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getGig()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    
    // Mark: IBActions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        do {
            let newGig = Gig(title: titleOfGigTextField.text ?? "No Title", discription: discriptionOfGigTextView.text, dueDate: datePicker.date)
            gigController.addGig(newGig: newGig) { (result) in
                guard (try? result.get()) != nil else { return }
                
                
            }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
//    func getGig() {
//        guard let gig = gig else { return }
//
//        gigController.fetchGigDetails(for: gig) { (result) in
//            if let gig = try? result.get() {
//                DispatchQueue.main.async {
//                    self.updateViews()
//                }
//            }
//        }
//    }
    
    func updateViews() {
        if let gig = gig {
            titleOfGigTextField.text = gig.title
            datePicker.date = gig.dueDate
            discriptionOfGigTextView.text = gig.discription
            self.title = gig.title
            
        } else {
            self.title = "New Gig"
        }
    }
}

