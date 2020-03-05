//
//  GigDetialViewController.swift
//  GigPart1
//
//  Created by Lambda_School_Loaner_218 on 12/5/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

protocol GigDelegate: class {
    func didCreate(gig: Gig)
}

class GigDetialViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    weak var delegate: GigDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        if let gig = gig {
            titleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let description = descriptionView.text, !description.isEmpty else { return }
        let dueDate = datePicker.date
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        gigController.createNewGig(with: gig) { result in
            if let gig = try? result.get(){
                self.delegate?.didCreate(gig: gig)
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
}
