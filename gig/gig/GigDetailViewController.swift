//
//  GigDetailViewController.swift
//  gig
//
//  Created by Gladymir Philippe on 7/10/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return
        }
        title = gig.title
        jobTitleTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        jobDescription.text = gig.description
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let gigTitle = jobTitleTextField.text,
            let gigDescription = jobTitleTextField.text,
            !gigTitle.isEmpty,
            !gigDescription.isEmpty else { return }
        
        let newGig = Gig(title: gigTitle, dueDate: dueDatePicker.date, description: gigDescription)
        
        gigController.createGig(for: newGig) { (error) in
            if let error = error {
                print("Error saving gig to database: \(error)")
            }
            
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
