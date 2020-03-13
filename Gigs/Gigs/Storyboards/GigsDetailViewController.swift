//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Bhawnish Kumar on 3/12/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gigName: String?
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var gigTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
getDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveGig(_ sender: Any) {
        guard let gigName = gigName else { return }
               
               // call the apiController's get details method
               gigController?.createGig(for: gigName, completion: { result in
                   if let gig = try? result.get() {
                       DispatchQueue.main.async {
                           self.updateViews(with: gig)
                       }
                   }
               })
        dismiss(animated: true, completion: nil)
        
    }
    
    private func getDetails() {
        guard let gigName = gigName else { return }

        // call the apiController's get details method
        gigController?.createGig(for: gigName, completion: { result in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: gig)
                }
            }
        })
    }
    
    private func updateViews(with gig: Gig) {
        gigTextView.text = gig.description
        jobTextField.text = gig.title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        datePicker.date = gig.dueDate
    }
    

  
}


