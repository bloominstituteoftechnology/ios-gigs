//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Harm on 5/11/23.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    //In the action of the save button, grab the values from the text field/view, and the date picker. Call the GigController's method to create (POST) a gig on the API. In the completion of this method, pop the view controller (on the correct queue) back to the table view controller.
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = jobTitleTextField.text, let description = jobDescriptionTextView.text else { return }
        let newGig = Gig(title: title, dueDate: datePicker.date, description: description)
        gigController.postGig(gig: newGig) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print("Gig posted successfully: \(success)")
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                case .failure(let failure):
                    print("Error posting gig: \(failure)")
                }
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            self.title = "Gig"
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            jobDescriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
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
