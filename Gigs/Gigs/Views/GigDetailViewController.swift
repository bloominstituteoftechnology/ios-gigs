//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Breena Greek on 3/19/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    var gig: Gig?
    var gigName: String!
    var gigController: GigController!
    
    //MARK: - IBOutlets

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!    
    
    //MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let date = datePickerView.date
        if let jobTitle = jobTitleTextField.text,
            let jobDescription = jobTitleTextField.text,
            !jobTitle.isEmpty,
            !jobDescription.isEmpty {
                
        gig?.title = jobTitle
        gig?.description = jobDescription
        gig?.dueDate = date
        
        let newGig = Gig(title: jobTitle, description: jobDescription, dueDate: date)
        
            gigController?.createGig(with: newGig, completion: { _ in
            })
            DispatchQueue.main.async {
        self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
//
//    func getDetails() {
//        gigController.fetchAllGigNames { (result) in
//            guard let animal = try? result.get() else { return }
//        }
//
//            DispatchQueue.main.async {
//                self.updateViews()
//
//            }
//        }

    func updateViews() {
        if let gig = gig {
        jobTitleTextField.text = gig.title
        descriptionTextView.text = gig.description
        datePickerView.setDate(gig.dueDate, animated: true)
        } else {
            self.title = "Add New Gig"
        }
    }
}
