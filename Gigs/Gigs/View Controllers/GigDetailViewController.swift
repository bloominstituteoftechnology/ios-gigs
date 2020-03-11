//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properties
    var gigController: GigController!
    var gig: Gig?

    @IBOutlet weak var jobTitleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let jobTitle = jobTitleText.text,
            let description = descriptionTextView.text,
            !jobTitle.isEmpty,
            !description.isEmpty else { return }

        let gig = Gig(title: jobTitle, description: description, dueDate: datePicker.date)
        gigController.createGig(gig: gig) { (result) in
                        
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
//            do {
//                let gig = try result.get()
//
//            } catch {
//                NSLog("Error saving new gig: \(error)")
//            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            jobTitleText.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    


}
