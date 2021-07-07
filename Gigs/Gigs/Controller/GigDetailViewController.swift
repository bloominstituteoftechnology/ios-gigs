//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/8/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController : GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let description = descriptionTextView.text, !description.isEmpty else { return }
        let dueDate = dueDatePicker.date
        gigController.createGig(title: title, description: description, dueDate: dueDate) { (result) in
            do {
                let gig = try result.get()
                self.gigController.gigs.append(gig)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                NSLog("Error getting gig after create")
                return
            }
           
            
        }
    }
    
    func updateViews() {
        if let gig = gig {
            title = ""
            titleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
          title = "New Gig"
        }
        
    }
    
}
