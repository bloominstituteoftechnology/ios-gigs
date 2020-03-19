//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by macbook on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    var gigController: GigController!    //  will be used to receive the GigsTableViewController's GigController through the prepare(for segue.
    
    var gig: Gig?    //will be used to receive a Gig from the GigsTableViewController's prepare(for segueif the user taps on a gig cell.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK - Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if gig == nil {
            //gigController.
            
            // TODO: In the action of the save button, grab the values from the text field/view, and the date picker. Call the GigController's method to create (POST) a gig on the API. In the completion of this method, pop the view controller (on the correct queue) back to the table view controller.
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
    
    func updateViews(with gig: Gig) {
        
        
        
        if gig == nil {
            title = "New Gig"
        } else {
            title = gig.title
            titleTextField.text = gig.title
            descriptionTextView.text = gig.description
        }
        
        
        // TODO : Date Picker
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yy"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        if let dueDate = formatter.date (from: gig.dueDate) {
//            datePicker.date = formatter(from: dueDate)
//        }
        
        
    }
    

}
