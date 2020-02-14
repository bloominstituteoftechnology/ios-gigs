//
//  GigDetailViewController.swift
//  GigS
//
//  Created by Nick Nguyen on 2/13/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var jobTitleTextField: UITextField! {
        didSet {
            jobTitleTextField.delegate = self
            jobTitleTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
     @IBOutlet weak var gigTextView: UITextView!
    var gigController : GigController!
    
    var gig: Gig? // don't put updateViews in didSet
       
    
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let titleText = jobTitleTextField.text,
            !titleText.isEmpty,
            let descriptionText = gigTextView.text,
            !descriptionText.isEmpty else {
                return
        }
        
        let gig = Gig(title: titleText, description: descriptionText, dueDate: datePicker.date)
        
        gigController?.createGig(with: gig, completion: { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
    }
    
    private func updateViews() {
        
        if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            title = gig.title
            gigTextView.text = gig.description
        }
        
        title = "New Gigs"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }

}
