//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_204 on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDateDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController?
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let gigController = gigController,
            let jobTitleString = jobTitleTextField.text,
            !jobTitleString.isEmpty else { return }
        
        let createdGig = Gig(title: jobTitleString, dueDate: dueDateDatePicker.date, description: descriptionTextView.text)
        
        gigController.createGig(with: createdGig) { error in
            if let error = error {
                switch error {                    
                case .noAuth:
                    print(NetworkError.noAuth.rawValue)
                case .badAuth:
                    print(NetworkError.badAuth.rawValue)
                case .otherError:
                    print(NetworkError.otherError.rawValue)
                case .badData:
                    print(NetworkError.badData.rawValue)
                case .noDecode:
                    print(NetworkError.noDecode.rawValue)
                case .noEncode:
                    print(NetworkError.noEncode.rawValue)
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    private func updateViews() {
        if let gig = gig {
            title = gig.title
            jobTitleTextField.text = gig.title
            dueDateDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
}
