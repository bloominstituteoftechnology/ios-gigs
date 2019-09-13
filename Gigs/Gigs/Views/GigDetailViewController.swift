//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Casualty on 9/12/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController : GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveGigButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text,
            !description.isEmpty,
            let description = descriptionTextView.text,
            !title.isEmpty else { return }
        let dueDate = dueDatePicker.date
        gigController.createGig(title: title, description: description, dueDate: dueDate) { (result) in
            do {
                let gig = try result.get()
                self.gigController.gigs.append(gig)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Error")
                return
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            jobTitleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
}
