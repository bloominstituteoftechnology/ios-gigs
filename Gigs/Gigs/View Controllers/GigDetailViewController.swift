//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/23/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
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
        guard let gig = gig else { return }
        textField.text = gig.title
        textView.text = gig.description
        datePicker.date = gig.dueDate
    }


    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if let title = textField.text,
            let description = textView.text,
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
    

}
