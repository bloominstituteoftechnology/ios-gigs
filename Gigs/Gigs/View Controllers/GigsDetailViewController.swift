//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/11/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    var gigController: GigController?
    var gig: Gig?
//    {
//        didSet {
//            updateViews()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func saveGig(_ sender: Any) {
       
        guard let jobTitle = jobTitleTextField.text, !jobTitle.isEmpty,
            let description = descriptionTextView.text, !description.isEmpty else { return }
        
        let date = datePicker.date
        
        gigController?.createGig(title: jobTitle, dueDate: date, description: description, completion: { (_) in
            DispatchQueue.main.async {
                print("New gig created!")
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    private func updateViews() {
        if let gig = gig {
            title = "\(gig.title)"
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
    
}
