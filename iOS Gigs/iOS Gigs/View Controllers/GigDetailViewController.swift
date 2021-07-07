//
//  GigDetailViewController.swift
//  iOS Gigs
//
//  Created by Vici Shaweddy on 9/12/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var jobTitleLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        jobTitleLabel.text = gig?.title
        descriptionTextView.text = gig?.description
        dueDatePicker.date = gig?.dueDate ?? Date()
        
        if gig == nil {
            self.navigationItem.title = "New Gig"
        } else {
            self.navigationItem.title = gig?.title
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let jobTitle = jobTitleLabel.text,
            !jobTitle.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty else {
                return
        }
        
        let gig = Gig(title: jobTitle, description: description, dueDate: dueDatePicker.date)
        self.gigController.createGig(with: gig) { (result) in
            switch result {
            case .failure(let networkError):
                print(networkError)
            case .success(_):
                DispatchQueue.main.async {
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
