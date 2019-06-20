 //
//  GigDetailViewController.swift
//  ios-Gigs
//
//  Created by Kat Milton on 6/19/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet var gigTitle: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var gigDescription: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = gigTitle.text,
            !title.isEmpty,
            let description = gigDescription.text,
            !description.isEmpty,
            let gigController = gigController else { return }
        let dueDate = datePicker.date
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        gigController.createGig(with: newGig) { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.gig = newGig
                self.updateViews()
                
                
            }
        }
        print(newGig)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
 
    func updateViews() {
        guard let newGig = gig,
            isViewLoaded else {
                title = "New Gig"
                return }
        saveButton.isEnabled = false
        title = newGig.title
        gigTitle.text = newGig.title
        datePicker.date = newGig.dueDate
        gigDescription.text = newGig.description
        
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
