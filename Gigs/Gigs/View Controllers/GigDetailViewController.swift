//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/8/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //Outlets
    @IBOutlet weak var jobTitleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    var delegate: GigsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    //Actions
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
       /* gigController.postGig(gig: Gig(title: "Testing", description: "Testing", dueDate: String(datePicker.date.description))) {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.update()
            }
        }*/
    }
    
    
    func updateViews() {
        jobTitleText.text = gig?.title ?? "New Gig"
        //datePicker?. = gig?.dueDate
        jobDescription.text = gig?.description
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
