//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Chris Dobek on 4/8/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    
    var gig: Gig?
    var gigController: GigController?
    
    
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViews()
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let gigName = jobTitleTextField.text,
                gigName.isEmpty == false,
                let description = descriptionTextView.text
                else {
                    return
            }

            let gig = Gig(title: gigName, description: description, dueDate: dueDatePicker.date)

                gigController?.addGig(for: gig) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(_):
                    print("Error saving gig.")
                }
            }
        }
    
    func updateViews() {
        if let gig = gig {
                self.title = gig.title
                jobTitleTextField.text = gig.title
                dueDatePicker.date = gig.dueDate
                descriptionTextView.text = gig.description
            } else {
                self.title = "New Gig"
            }
        }
    
}
