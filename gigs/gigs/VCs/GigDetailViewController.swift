//
//  GigDetailViewController.swift
//  gigs
//
//  Created by ronald huston jr on 5/6/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    var gig: Gig?
    var gigController: GigController?
    
    @IBOutlet weak var gigNameTextField: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func save(_ sender: Any) {
        guard let gigName = gigNameTextField.text,
            gigName.isEmpty == false,
            let description = descriptionTextView.text
            else {
                return
        }
        
        let gig = Gig(title: gigName, description: description, dueDate: dueDate.date)
        
        //  may want to implement .postGig method to save functionality
        //  it doesn't look like save method will work considering the way
        //  postGig() method is built...
    }
    
}
