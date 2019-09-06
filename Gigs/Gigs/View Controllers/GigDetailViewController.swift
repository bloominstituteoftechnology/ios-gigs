//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/5/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - Outlets

    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    // MARK: - Action Handlers
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let date = dueDate.date
        guard let title = jobTitle.text else { return }
        guard let description = jobDescription.text else { return }
        
        let newGig = Gig(title: title, description: description, dueDate: date)
        
        gigController.createGig(with: newGig, completion: { (networkError) in
            
            if let error = networkError {
                NSLog("Error occurred creating gig: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let gig = gig else {
            self.jobTitle.text = "New Gig"
            return
        }
        jobTitle.text = gig.title
        dueDate.date = gig.dueDate
        jobDescription.text = gig.description
    }
}
