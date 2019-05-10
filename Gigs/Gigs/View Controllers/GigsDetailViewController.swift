//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Christopher Aronson on 5/9/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {
    // MARK: - Properties
    var gigController: GigController?
    
    // Mark: - Computed Properties
    var gig: Gig? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }

    // MARK: - IBOtlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        if gig == nil {
            title = "New Gig"
        }
        
        
    }

    
    // MARK: - updateViews()
    func updateViews() {
        guard let currentGig = gig else { return }
        
        jobTitleTextField.text! = currentGig.title
        jobDescriptionTextView.text! = currentGig.description
        dueDatePicker.date = currentGig.dueDate
        
//        jobDescriptionTextView.text = gig.description ?? ""
    }

    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let date = dueDatePicker.date
        guard let title = jobTitleTextField.text else { return }
        guard let description = jobDescriptionTextView.text else { return }
        
        gigController?.createGig(title: title, description: description, dueDate: date, completion: { (error) in
            if let error = error {
                print(error)
                return
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
}
