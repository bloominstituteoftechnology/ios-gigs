//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/8/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let gigTitle = textField.text,
            let gigDescription = textView.text
            else { return }
        
        let gig = Gig(title: gigTitle, description: gigDescription, dueDate: datePicker.date)
        
        gigController.createGigs(for: gig) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                print("Error saving gig")
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            self.title = gig.title
            textField.text = gig.title
            datePicker.date = gig.dueDate
            textView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }

}
