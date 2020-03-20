//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/19/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    //MARK: - Properties
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text, !title.isEmpty,
            let description = descriptionTextView.text, !description.isEmpty else { return }
        
            let newGig = Gig(title: title, description: description, dueDate: datePicker.date)

            gigController.postAGig(with: newGig) { (result) in
                do {
                    let _ = try result.get()
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth:
                            print("Error: No bearer token exists.")
                        case .unauthorized:
                            print("Error: Bearer token invalid.")
                        case .noData:
                            print("Error: The response had no data.")
                        case .decodeFailed:
                            print("Error: The data could not be decoded.")
                            case .encodeFailed:
                            print("Error: The data could not be decoded")
                        case .otherError(let otherError):
                            print("Error: \(otherError)")
                        }
                    } else {
                        print("Error: \(error)")
                    }
                }
            }
    }
    
    //MARK: - Functions
    func updateViews() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            descriptionTextView.text = gig.description
            datePicker.setDate(gig.dueDate, animated: true)
            self.title = gig.title
        } else {
            self.title = "New Gig"
        }
    }
}
