//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jonathan Ferrer on 5/16/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    var gigController: GigController!
    var gig: Gig?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func updateViews() {
        guard let gig = gig else {
            navigationItem.title = "New Gig"
            return
        }

        titleTextField.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextView.text = gig.description


    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
        let description = descriptionTextView.text, !description.isEmpty else { return }
        let dueDate = datePicker.date

        gigController.createGig(title: title, dueDate: dueDate, description: description) { (error) in
            if let error = error{
                print(error)
                return
            }
            self.navigationController?.popViewController(animated: true)
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
