//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-31.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleField.text, !title.isEmpty,
            let description = descriptionView.text, !description.isEmpty
            else { return }
        let date = dueDatePicker.date
        
        let gig = Gig(title: title, dueDate: date, description: description)
        gigController.create(gig: gig) { (success) in
            if !success {
                DispatchQueue.main.async {
                    // TODO: implement passing the error message back up to this level for more descriptive alert
                    let alert = UIAlertController(title: "Gig creation failed.", message: "Please refer to console log for error details.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            titleField.text = gig.title
            descriptionView.text = gig.description
            dueDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }
}
