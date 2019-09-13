//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/12/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtvJobDescription: UITextView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        guard let title = txtJobTitle.text, !title.isEmpty,
              let description = txtvJobDescription.text, !description.isEmpty
            else { return }
        let newGig = Gig(title: title, description: description, dueDate: datePicker.date)
        
        gigController.addGig(newGig) { (error) in
            if let error = error {
                print("Error adding gig: \(error)")
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error", message: "Unable to save gig. Please try again later.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            txtJobTitle.text = gig.title
            datePicker.date = gig.dueDate
            txtvJobDescription.text = gig.description
            btnSave.isEnabled = false
            txtJobTitle.isEnabled = false
            datePicker.isEnabled = false
            txtvJobDescription.isEditable = false
        } else {
            title = "New Gig"
            btnSave.isEnabled = true
            txtJobTitle.isEnabled = true
            datePicker.isEnabled = true
            txtvJobDescription.isEditable = true
        }
    }
}
