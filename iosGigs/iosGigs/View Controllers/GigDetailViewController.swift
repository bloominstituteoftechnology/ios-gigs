//
//  GigDetailViewController.swift
//  iosGigs
//
//  Created by denis cedeno on 11/7/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//
import Foundation
import UIKit

class GigDetailViewController: UIViewController {

    var gigController: GigController?
    var gig: Gig?
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews(){
        if let gig = gig {
        title = gig.title
        jobTitleTextField.text = gig.title
        descriptionTextView.text = gig.description
        dueDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let title = jobTitleTextField.text,
        !title.isEmpty,
        let description = descriptionTextView.text,
        !description.isEmpty
        else { return }
        let dueDate = dueDatePicker.date
        
        
        let newGig = Gig(title: title, description: description, dueDate: dueDate)

        if ((gigController?.gigs.firstIndex(where: {$0.title == newGig.title})) != nil){
            print("job already exsists")
        } else {
        gigController?.createGigs(with: newGig, completion: { (Result) in
             DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
            }
        })
        }
        }
    
    
    


}
