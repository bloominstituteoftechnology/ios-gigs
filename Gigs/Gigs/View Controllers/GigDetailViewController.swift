//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/13/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var gigName: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescription: UITextView!
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = gigName.text,
            let description = gigDescription.text else { return }
        
        let date = gigDatePicker.date
        
        gigController.createGig(title: name, dueDate: date, description: description) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - Properties
    var gig: Gig?
    var gigController: GigController!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        if let gig = gig {
            gigName.text = gig.title
            gigDatePicker.date = gig.dueDate
            gigDescription.text = gig.description
        } else {
            navigationItem.title = "New gig"
        }
    }

}
