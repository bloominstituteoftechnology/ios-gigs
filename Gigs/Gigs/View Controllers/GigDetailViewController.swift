//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Juan M Mariscal on 3/19/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - IBOutlets
    @IBOutlet weak var gigTitleTxtField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTxtView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews(with gig: Gig) {
        if gig.title.isEmpty {
            gigTitleTxtField.text = "New Gig"
        }
        gigTitleTxtField.text = gig.title
        gigDescriptionTxtView.text = gig.description
        datePicker.setDate(gig.dueDate, animated: true)
        
    }
    
    // MARK: - IBActions
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        guard let title = gigTitleTxtField.text else { return }
        guard let description = gigDescriptionTxtView.text else { return }
        let newGig = Gig(title: title, description: description, dueDate: datePicker.date)
        gigController.postGig(with: newGig) { (error) in
            guard error == nil {
                print("Error posting new Gig \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.updateViews(with: newGig)
            }
        }
    }
    

}
