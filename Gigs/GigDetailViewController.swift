//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Kenneth Jones on 5/12/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var gigTextField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let gigTitle = gigTextField.text,
            let gigDescription = descriptionTextView.text,
            !gigTitle.isEmpty,
            !gigDescription.isEmpty else { return }
        
        let newGig = Gig(title: gigTitle, description: gigDescription, dueDate: gigDatePicker.date)
        gigController.addGig(with: newGig) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateViews() {
        if let gig = gig {
            title = gig.title
            gigTextField.text = gig.title
            descriptionTextView.text = gig.description
            gigDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }

}
