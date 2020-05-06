//
//  DetailViewController.swift
//  iOs-Gigs
//
//  Created by SenorLappy on 24/1/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var jobTitleTxtField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    var gig: Gig?
    var gigController: GigController?
    
    //IBOutlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gig != nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        // Do any additional setup after loading the view.
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // IB Actions
    @IBAction func saveBtnWasPressed(_ sender: UIBarButtonItem) {
        if let title = jobTitleTxtField.text,
            let description = descriptionTxtView.text,
            !title.isEmpty,
            !description.isEmpty {
            let date = datePicker.date
            let newGig = Gig(title: title, description: description, dueDate: date)
            
            gigController?.createGig(newGig, completion: { (error) in
                if let error = error {
                    print(error)
                }
            })
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews() {
        guard let gig = gig else { return }
        jobTitleTxtField.text = gig.title
        descriptionTxtView.text = gig.description
        datePicker.date = gig.dueDate
        
    }
    

}
