//
//  GigDetailViewController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?


    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = jobDescriptionTextView.text,
            !description.isEmpty,
            let gigController = gigController else { return }
        let dueDate = dueDatePicker.date
        let newGig = Gig(title: title, dueDate: dueDate, description: description)
        
        gigController.createGig(title: title, description: description, dueDate: dueDate) { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.gig = newGig
                self.updateViews()
                
                
            }
        }
        print(newGig)
        self.navigationController?.popViewController(animated: true)
        
    }

    
    func updateViews() {
        
        if gig != nil {
            title = gig?.title
            jobTitleTextField.text = gig?.title
            dueDatePicker.date = gig!.dueDate
            jobDescriptionTextView.text = gig?.description
        } else {
            title = "Add New Gig"
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
