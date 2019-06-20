//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 6/20/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextView: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    let df = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if let newGigTitle = jobTitleTextView.text,
            !newGigTitle.isEmpty,
            let newGigDescription = descriptionTextView.text,
            !newGigDescription.isEmpty {
            let newGigDueDate = dueDatePicker.date
            let newGig = Gig(title: newGigTitle, description: newGigDescription, dueDate: newGigDueDate)
            gigController.addGig(newGig: newGig) { (error) in
                if let error = error {
                    print("Error occured adding new gig: \(error)")
                }else  {
                    
                }
            }
        }
    }
    
    func updateViews() {
        
        df.dateStyle = .short
        df.timeStyle = .short
        
        if gig == nil {
            title = "New Gig"
        }else {
            guard let gig = gig else { return }
            jobTitleTextView?.text = gig.title
            dueDatePicker?.date = gig.dueDate
            descriptionTextView?.text = gig.description
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
