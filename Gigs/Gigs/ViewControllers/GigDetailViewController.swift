//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/14/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    var gig: Gig?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            titleTextField.text = gig.title
            datePicker.setDate(gig.dueDate, animated: true)
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty {
            let gig = Gig(title: title, dueDate: datePicker.date, description: description)
            if let gigController = gigController {
                if gigController.gigs.contains(gig) {
                    let alert = UIAlertController(title: "This gig is already saved.", message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    present(alert, animated: true, completion: nil)
                } else {
                    gigController.createGig(with: gig, completion: { (result) in
                        switch result {
                        case .success(true):
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print("Error creating gig: \(error)")
                        default:
                            return
                        }
                    })
                }
            }
        }
    }

}
