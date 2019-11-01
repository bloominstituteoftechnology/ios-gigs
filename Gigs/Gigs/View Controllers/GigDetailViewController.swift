//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Niranjan Kumar on 10/31/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    
    var gigController: GigController?
    var gig: Gig?
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    // MARK: - Methods

    private func updateViews() {
       
        if let gig = gig {
        navigationItem.title = gig.title
        jobTitle.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextField.text = gig.description
        } else {
            navigationItem.title = "New Gig"
        }
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let gigController = gigController else { return }
        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty else { return }
        guard let description = descriptionTextField.text, !description.isEmpty else { return }
        let date = datePicker.date
        
        let gig = Gig(title: jobTitle, description: description, dueDate: date)
        
//        gigController.createGig(for: gig, completion: { (result) in
//            DispatchQueue.main.async {
//                self.gig = gig
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        
                gigController.createGig(for: gig) { (result) in
                    if let gig = try? result.get() { // when is the try? result.get() used and when is it not?
                        DispatchQueue.main.async {
                            self.gig = gig
                            self.navigationController?.popViewController(animated: true)
                        }
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
