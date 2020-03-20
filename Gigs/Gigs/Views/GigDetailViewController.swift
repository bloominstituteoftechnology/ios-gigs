//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Breena Greek on 3/19/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    var gigName: String!
    var gigController: GigController!
    
    //MARK: - IBOutlets

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!    
    
    //MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()

    }
    
    func getDetails() {
        gigController.fetchDetails(for: gigName) { (result) in
            guard let gig = try? result.get() else { return }
            
            DispatchQueue.main.async {
                self.updateViews(with: gig)
                
            }
        }
    }

    private func updateViews(with gig: Gig) {
        jobTitleTextField.text = gig.title
        descriptionTextView.text = gig.description
        datePickerView.setDate(gig.dueDate, animated: true)
        
    }
}
