//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/7/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: Properties
    
    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViews()
    }
    
    //MARK: Actions
    
    private func updateViews() {
        if let gig = gig {
        textField.text = gig.title
        datePicker.date = gig.dueDate
        textView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard let gigName = textField.text,
            let gigDescription = textView.text,
            textField.text != nil,
            textView.text != nil else {return}
            let gig = Gig(title: gigName, description: gigDescription, dueDate: datePicker.date)
            gigController.createGig(with: gig) { (_) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    

}
