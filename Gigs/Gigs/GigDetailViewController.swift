//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by admin on 10/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var gigController: GigController!
    
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        
        title = gig?.title
        jobTitleTextField.text = gig?.title
        
        dueDatePicker.date = gig!.dueDate
        descriptionTextField.text = gig?.description
        
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
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
