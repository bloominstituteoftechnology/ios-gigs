//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Michael on 1/16/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    var gigController: GigController?
    
    var gig: Gig? 
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDateDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        guard let title = jobTitleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        let date = dueDateDatePicker.date
        
        gigController.createAGig(title: title, description: description, dueDate: date, completion: { result in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    func updateViews() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            dueDateDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
