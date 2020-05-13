//
//  GigDetailViewController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var gigDueDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTextField: UITextView!
    
    //MARK: - Properties
    var gigController: GigController?
    var gig: Gigs?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let gigTitle = gigTitleTextField.text, !gigTitle.isEmpty,
            let gigDescription = gigDescriptionTextField.text, !gigDescription.isEmpty,
            let gigController = gigController else { return }
        let date = gigDueDatePicker.date
        
        gigController.createGig(title: gigTitle, dueDate: date, description: gigDescription) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    //MARK: - Helper Function
    private func updateViews(){
        if let gig = self.gig{
            navigationItem.title = "Gigs"
            gigTitleTextField.text = gig.title
            gigDueDatePicker.date = gig.dueDate
            gigDescriptionTextField.text = gig.description
        } else{
            navigationItem.title = "New Gig"
        }
    }
}
