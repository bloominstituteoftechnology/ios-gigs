//
//  GigDetailViewController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/13/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - Properties
    
    var gigController: GigController?
    
    var gig: Gig?
    
    // MARK: - Outlets
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionTF: UITextView!
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        var babyGig = Gig(title: titleTF.text!, description: descriptionTF.text!, dueDate: datePicker.date)
        gigController?.addGig(gig: babyGig) { (error) in if let error = error {
            print(error)
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let gig = gig else { self.title = "New Gig"
            return
        }
        titleTF.text = gig.title
        descriptionTF.text = gig.description
        datePicker.date = gig.dueDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
