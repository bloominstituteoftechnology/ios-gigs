//
//  GigDetailViewController.swift
//  ios-gigs
//
//  Created by Shawn James on 4/9/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let gigTitle = titleTextField.text,
            let gigDescription = descriptionTextView.text
            else { return }
        
        let newGig = Gig(title: gigTitle, dueDate: dateView.date, description: gigDescription)
        
        gigController?.postAGig(for: newGig) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                print("Error saving gig.")
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            self.title = gig.title
            titleTextField.text = gig.title
            dateView.date = gig.dueDate
            descriptionTextView.text = gig.description
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
