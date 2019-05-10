//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by morse on 5/9/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    var gigController: GigController?
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, let dueDate = datePicker?.date, let description = descriptionTextView.text else { return }
        
        gigController?.createGig(title: title, dueDate: dueDate, description: description, completion: { error in
            if let error = error {
                print("Error creating message: \(error)")
            }
        })
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
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
