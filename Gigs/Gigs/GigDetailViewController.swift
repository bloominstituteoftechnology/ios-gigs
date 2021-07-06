//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Isaac Lyons on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Properties
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    //MARK: Private
    
    private func updateViews() {
        if let gig = gig {
            titleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    
    //MARK: Actions

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let description = descriptionTextView.text,
            !title.isEmpty,
            !description.isEmpty else { return }
        
        let gig = Gig(title: title, dueDate: datePicker.date, description: description)
        
        // Only add the gig if it doesn't already exist
        if gigController.gigs.contains(gig) {
            let alert = UIAlertController(title: "Unable to create gig",
                                          message: "This gig already exists",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            gigController.createGig(gig: gig) { (result) in
                do {
                    let newGig = try result.get()
                    
                    DispatchQueue.main.async {
                        self.gigController.gigs.append(newGig)
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    NSLog("Error getting new gig details: \(error)")
                }
            }
        }
    }
}
