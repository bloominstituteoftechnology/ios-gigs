//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Zack Larsen on 12/5/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        
        if let gig = gig {
            title = gig.title
            titleTextField.text = gig.title
            datePicker.date = gig.dueDate
            textView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
                let description = textView.text else { return }
            
            gigController.createGig(with: title, dueDate: datePicker.date, description: description) { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    
    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var textView: UITextView!
    
}

// Do any additional setup after loading the view.





