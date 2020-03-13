//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bradley Diroff on 3/12/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let title = titleField.text,
            !title.isEmpty,
            let description = descriptionView.text,
            !description.isEmpty {
            let gig = Gig(title: title, dueDate: "\(datePicker.date)", description: description)
            
            gigController?.createGig(with: gig, completion: { error in
                if let error = error {
                    NSLog("Error occurred during gig creation: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    func updateViews() {
        if let gig = gig {
            titleField.text = gig.title
            descriptionView.text = gig.description
            self.title = gig.title
        } else {
            self.title = "New Gig"
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
