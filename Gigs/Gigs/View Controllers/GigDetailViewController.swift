//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/12/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescription: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

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

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = gigField.text,
            !title.isEmpty,
            let description = gigDescription.text,
            !description.isEmpty else { return }
        let newGig = Gig(title: title, description: description, dueDate: gigDatePicker.date)
        gigController.postGig(for: newGig) { result in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    // MARK: - Methods
    private func updateViews() {
        if let gig = gig {
            gigField?.text = gig.title
            gigDescription.text = gig.description
            gigDatePicker.date = gig.dueDate
        } else {
            self.navigationItem.title = "New Gig"
        }
    }
    
}
