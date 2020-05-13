//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Ian French on 5/12/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    
    
    var gigController: GigController!
    
    var gig: Gig?
    
    
    
    @IBOutlet weak var DetailTextView: UITextView!
    
    
    @IBOutlet weak var DatePickerOutlet: UIDatePicker!
    
    
    @IBOutlet weak var TitleTextField: UITextField!
    
    
    
    
    @IBAction func SaveTapped(_ sender: Any) {
        
        
        guard let title = TitleTextField.text, !title.isEmpty,
            let description = DetailTextView.text, !description.isEmpty  else { return }
        
        let newGig = Gig(title: title, dueDate: DatePickerOutlet.date, description: description)
        
        gigController.createGig(gig: newGig) { (result) in
            do {
                
                let saveGig = try result.get()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController( animated: true)
                }
            }  catch  {
                print("Error saving")
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        updateViews()
        
    }
    
    
    func updateViews() {
        if let gig = gig {
            DetailTextView.text = gig.description
            TitleTextField.text = gig.title
            DatePickerOutlet.setDate(gig.dueDate, animated: true)
            
        } else {
            title = "New Gig"
        }
    }
    
}
