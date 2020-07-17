//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 15/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //MARK: - Properties
    var gigController: GigController!
    var gig: Gig?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descTextView: UITextView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text, let description = descTextView.text else {
            return
        }
        
        gigController.addNewGig(title: title, description: description, dueDate: dueDatePicker.date) { (error) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    //MARK: - Private Functions
    private func updateViews() {
        guard let gig = gig else {
            title = "Add New Gig"
            return
        }
        
        title = gig.title
        jobTitleTextField.text = gig.title
        descTextView.text = gig.description
        dueDatePicker.date = gig.dueDate
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
