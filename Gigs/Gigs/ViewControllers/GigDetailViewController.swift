//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 11/7/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController?
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let dueDate = datePicker.date
        if let gigTitle = gigTitleTextField.text, !gigTitle.isEmpty,
            let description = descriptionTextView.text, !description.isEmpty
//            let gigs = gigController?.gigs
        {
            
            let newGig = Gig(title: gigTitle, description: description, dueDate: dueDate)
            gigController?.createGig(from: newGig) { result in
                DispatchQueue.main.async {
//                    for gig in gigs {
//                        if newGig != gig {
//                            self.gigController?.createGig(from: newGig) { result in
//                                DispatchQueue.main.async {
//                                    self.navigationController?.popViewController(animated: true)
//                                }
//                            }
//                        } else {
//                            let alertController = UIAlertController(title: "This Gig Already Exists", message: "Please create a new Gig", preferredStyle: .alert)
//                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                            alertController.addAction(alertAction)
//                            self.present(alertController, animated: true)
//                        }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func updateViews() {
        if let gig = gig {
            title = "\(gig.title)"
            gigTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
}
