//
//  DetailGigViewController.swift
//  Gigs
//
//  Created by Matthew Martindale on 3/18/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class DetailGigViewController: UIViewController {
    
    var gigController: GigController?
    var gig: Gig?
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(gig: gig)

    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let date = datePicker.date
        if let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty {
            let newGig = Gig(title: title, dueDate: date, description: description)
            gigController?.addGig(with: newGig, completion: { NetworkError in
                if let error = NetworkError {
                    switch error {
                        case .noAuth:
                            print("Error: No bearer token exists")
                        case .badAuth:
                            print("Error: Bearer token invalid")
                        case .noData:
                            print("Error: No data")
                        case .decodeFailure:
                            print("Error: Decode failure")
                        case .otherError(let otherError):
                            print("Error: \(otherError)")
                        case .encodeFailure:
                            print("Error: Encode failure")
                        }
                    }
            })
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews(gig: Gig?) {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.setDate(gig.dueDate, animated: true)
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }


}
