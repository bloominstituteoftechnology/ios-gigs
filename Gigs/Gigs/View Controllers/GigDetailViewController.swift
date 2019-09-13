//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bobby Keffury on 9/12/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    
    //MARK: - Properties
    
    var gigController: GigController?
    var gig: Gig?
    
    
    //MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Methods
    
    private func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return
        }
        
        title = gig.title
        gigDescriptionTextView.text = gig.description
        gigDatePicker.date = gig.dueDate
        gigTitleTextField.text = gig.title
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let gigController = gigController, let description = gigDescriptionTextView.text, let title = gigTitleTextField.text else {
            return
        }
        
        let gigy = Gig(title: title, description: description, dueDate: gigDatePicker.date)
        
        gigController.createGig(with: gigy) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
        
        
    }
    

}
