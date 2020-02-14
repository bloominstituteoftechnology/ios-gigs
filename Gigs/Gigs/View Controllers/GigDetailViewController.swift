//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by scott harris on 2/13/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let description = descriptionTextField.text, !description.isEmpty else { return }
        let gig = Gig(title: title, description: description, dueDate: dueDatePicker.date)
        gigController.createGig(gig: gig) { (result) in
            do {
                let _ = try result.get()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                        case .noAuth:
                            NSLog("No Bearer token, please log in.")
                        case .badAuth:
                            NSLog("Bearer token invalid.")
                        case .otherError:
                            NSLog("Generic netowrk error occured")
                        case .badData:
                            NSLog("Data received was invalid, corrupt, or doesnt exist")
                        case .noDecode:
                            NSLog("Gig JSON data could not be decoded")
                        default:
                            NSLog("Other error ocured")
                        
                    }
                }
            }
        }
        
    }
    
    func updateViews() {
        if let gig = gig {
            titleTextField.text = gig.title
            descriptionTextField.text = gig.description
            dueDatePicker.setDate(gig.dueDate, animated: true)
        } else {
            title = "New Gig"
        }
    }
    
}
