//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Clean Mac on 5/16/20.
//  Copyright © 2020 LambdaStudent. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var apiController: APIController?
    var gig: Gig?
    
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobDueDate: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ secnder: Any) {
        guard let title = jobTitle.text,
        let description = jobDescription.text,
        let apiController = apiController else
    { return }
        let date = jobDueDate.date
        
        apiController.newGig(title: title, dueDate: date, description: description) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }

        
    
    }
    
    private func updateViews() {
        if let gig = gig {
        jobTitle.text = gig.title
        jobDueDate.date = gig.dueDate
        jobDescription.text = gig.description
        } else {
            navigationItem.title = "New Gig"
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
