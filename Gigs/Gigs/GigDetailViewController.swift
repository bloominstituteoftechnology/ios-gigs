//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Morgan Smith on 1/23/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController = GigController()
    
    var gig: Gig?
    
    @IBOutlet weak var jobText: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var desText: UITextView!
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let newGig = Gig(title: jobText.text ?? "No Title", description: desText.text, dueDate: datePicker.date)
        
        gigController.createGigs(with: newGig) { (result) in
            guard (try? result.get()) != nil else {return}
            do {
                let success = try result.get()
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } catch {
                print("Unable to create new gig: \(error)")
            }
        }
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateViews()
            
        }
        
        func updateViews() {
            if let gig = gig {
                jobText.text = gig.title
                datePicker.date = gig.dueDate
                desText.text = gig.description
            } else {
                self.title = "New Gig"
            }
        }
        
        
}

