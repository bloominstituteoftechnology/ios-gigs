//
//  GigDetailViewController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    let dateFormatter = DateFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let gigTitle = jobTitleTextField.text,
            !gigTitle.isEmpty,
            let description = jobDescriptionTextView.text,
            !description.isEmpty else {

                print("gig not saved")
                return }
        
        
        gigController?.createGig(title: gigTitle, description: description, dueDate: dueDatePicker.date, completion: { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                
            }
        })
        
    }

    
    private func updateViews() {
        
        guard let selectedGig = gig,
            isViewLoaded else {
                title = "Add New Gig"
                return
        }
        
            title = selectedGig.title
            jobTitleTextField.text = selectedGig.title
            dueDatePicker.date = selectedGig.dueDate
            jobDescriptionTextView.text = selectedGig.description
            saveButton.isEnabled = false
        
    
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
