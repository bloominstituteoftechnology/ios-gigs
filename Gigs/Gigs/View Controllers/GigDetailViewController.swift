//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by morse on 10/31/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var gig: Gig?
    var gigController: GigController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if gig != nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        updateViews()
    }
    
    func updateViews() {
        guard let gig = gig else {
            saveButton.isEnabled = false
            return }
        titleTextField.text = gig.title
        descriptionTextView.text = gig.description
        datePicker.date = gig.dueDate
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let title = titleTextField.text,
            let description = descriptionTextView.text,
            !title.isEmpty,
            !description.isEmpty {
            let date = datePicker.date
            let newGig = Gig(title: title, description: description, dueDate: date)
            
            gigController?.add(gig: newGig, completion: { error in
                if let error = error {
                    print(error)
                }
            })
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
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
