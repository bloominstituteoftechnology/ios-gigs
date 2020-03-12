//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Wyatt Harrell on 3/12/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text, !title.isEmpty else { return }
        guard let description = descriptionTextView.text, !description.isEmpty else { return }
        
        let newGig = Gig(title: title, description: description, dueDate: dateDatePicker.date)
        gigController.createGig(with: newGig) { (result) in
            do {
                    let gig = try result.get()
                    DispatchQueue.main.async {
                        self.gigController.gigs.append(gig)
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth: //You could make an alert controller for these
                            NSLog("No bearer token exists") //These are developer facing but you could have one for user one for developer
                        case .badAuth:
                            NSLog("Bearer token invalid")
                        case .otherError:
                            NSLog("Other error occured, see log")
                        case .badData:
                            NSLog("No data received, or data corrupted")
                        case .noDecode:
                            NSLog("JSON could not be decoded")
                        }
                    }
                }
            }
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            jobTitleTextField.text = gig.title
            descriptionTextView.text = gig.description
            dateDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }
}
