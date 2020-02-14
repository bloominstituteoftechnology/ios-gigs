//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Enrique Gongora on 2/13/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - Variables
    var gigController: GigController!
    var gig: Gig?
    
    //MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - IBActions
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let textField = textField.text, !textField.isEmpty, let textView = textView.text, !textView.isEmpty else { return }
        let dueDate = datePicker.date
        let newGig = Gig(title: textField, description: textView, dueDate: dueDate)
        
        gigController.createGig(with: newGig) { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Function
    func updateViews() {
        if let gig = gig {
            self.navigationItem.title = gig.title
            self.textField.text = gig.title
            self.datePicker.date = gig.dueDate
            self.textView.text = gig.description
        } else {
            self.navigationItem.title = "New Gig"
        }
    }
    
}
