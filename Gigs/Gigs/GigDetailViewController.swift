//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/6/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gigNameTextField: UITextField!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gig != nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        updateViews()
    }
    func updateViews() {
        guard let gig = gig else { return }
        gigNameTextField.text = gig.title
        descriptionTextView.text = gig.description
        datePicker.date = gig.dueDate
        
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let gigName = gigNameTextField.text,
            gigName.isEmpty == false,
            let description = descriptionTextView.text else { return }
        
        let gig = Gig(title: gigName, dueDate: datePicker.date, description: description)
        
        gigController?.addGig(gig: gig, completion: { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
        self.navigationController?.popViewController(animated: true)
    }
}
