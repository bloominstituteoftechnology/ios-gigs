//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Dennis Rudolph on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    
    var gig: Gig?
    
    @IBOutlet weak var gigTextField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let gigString = gigTextField.text,
            !gigString.isEmpty,
            let gigDescription = gigDescriptionTextView.text,
            !gigDescription.isEmpty else { return }
        let gigDate = gigDatePicker.date
        
        let gig = Gig(title: gigString, dueDate: gigDate, description: gigDescription)
        
        gigController?.createGig(gig: gig, completion: {
            DispatchQueue.main.async {
                self.gig = gig
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    func updateViews() {
        if let gig = gig {
            gigTextField.text = gig.title
            gigDescriptionTextView.text = gig.description
            gigDatePicker.date = gig.dueDate
        } else {
            self.title = "New Gig"
        }
    }
}
