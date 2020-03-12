//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Lydia Zhang on 3/12/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit


class GigDetailViewController: UIViewController {

    var gigController: GigController!
    var gigs: Gig?
    
    @IBOutlet weak var titleText: UINavigationItem!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text, let describe = descriptionTextView.text,
            !title.isEmpty,!describe.isEmpty else {return}
        //let newGig = Gig(title: title, description: describe, dueDate: datePicker.date)
        gigController.createGig(with: title, dueDate: datePicker.date, description: describe) { (_) in
            DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
            }
            }
        }
    
    
    
    func updateViews() {
        if let gig = gigs {
            titleText.title = gig.title
            jobTitleTextField.text = gig.title
            descriptionTextView.text = gig.description
            datePicker.date = gig.dueDate
        } else {
            titleText.title = "New Gig"
            descriptionTextView.text = " "
        }
    }
    
}
