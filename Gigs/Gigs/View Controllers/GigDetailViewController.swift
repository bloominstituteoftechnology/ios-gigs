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

    override func viewDidLoad() {
        super.viewDidLoad()

        noGigUpdateViews()
    }
    
    func getGig() {
        guard let gigController = gigController,
            let gig = gig else { return }
        
        gigController.fetchDetails(for: gig) { result in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: gig)
                }
            }
        }
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
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    func noGigUpdateViews() {
        self.title = "Add New Gig"
    }
    func updateViews(with newGig: Gig) {

        if gig == nil {
            self.title = "New Gig"
        }else {
          
            jobTitleTextView?.text = newGig.title
            dueDatePicker?.date = newGig.dueDate
            descriptionTextView?.text = newGig.description
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
