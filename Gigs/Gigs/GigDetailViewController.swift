//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 13/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDetail: UITextView!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = jobTitleTextField.text,
            let description = jobDetail.text else { return }
        
        let dueDate = dueDatePicker.date
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        gigController.createGig(newGig) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            jobDetail.text = ""
            jobDetail.isEditable = true
            return
        }
        
        jobTitleTextField.borderStyle = .none
        jobTitleTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        jobDetail.text = gig.description
        jobDetail.isEditable = false
    }
}
