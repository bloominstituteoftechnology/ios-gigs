//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/13/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    var gigController: GigController!
    var gig: Gig?
    
    // MARK:  View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
   // MARK: Methods
    func updateViews() {
    if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        }
    }

    
    //MARK: Actions
    
    @IBAction func saveGigButton(_ sender: UIBarButtonItem) {
        guard let titleText = jobTitleTextField.text,
                   !titleText.isEmpty,
                   let descriptionText = descriptionTextView.text,
                   !descriptionText.isEmpty else {
                       return
               }
               
        let gig = Gig(title: titleText, description: descriptionText, dueDate: datePicker.date)
               
               gigController?.createGig(with: gig, completion: { (result) in
                   DispatchQueue.main.async {
                       self.navigationController?.popViewController(animated: true)
                   }
               })
    }
    
}
