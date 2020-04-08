//
//  GigDetailViewController.swift
//  iOSGigs
//
//  Created by Hunter Oppel on 4/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var gigNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViews()
    }
    
    // MARK: - Action handlers
    
    @IBAction func save(_ sender: Any) {
        guard let gigName = gigNameTextField.text,
            gigName.isEmpty == false,
            let description = descriptionTextView.text
            else {
                return
        }
        
        let gig = Gig(title: gigName, description: description, dueDate: datePicker.date)
        
        gigController.postGig(gig: gig) { result in
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
            gigNameTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
}
