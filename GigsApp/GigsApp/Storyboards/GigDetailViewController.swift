//
//  GigDetailViewController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/8/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var gigController: GigController!
    var gigsTableViewController: GigsTableViewController?
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if gig == nil {
            self.title = "New Gig"
        } else {
            self.title = gig?.title
        }
        
        updateViews()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let title = jobTitleTextField?.text,
            let date = datePicker?.date,
            let description = textView?.text {
            
            let thisGig = Gig(title: title, dueDate: date, description: description)
            
            if gig == nil {
                // Create gig
                gigController.createGig(thisGig) { result in
                    DispatchQueue.main.async {
                        self.gigController.gigs.append(thisGig)
                        self.gigsTableViewController?.tableView.reloadData()
                    }
                }
            } else {
                // Update gig
                print(thisGig)
            }
        }
        
        // Use this if you present modally
        //dismiss(animated: true, completion: nil)
        
        // Use this if you Show
        // TODO: Should I call it here or should the caller do it?
        navigationController?.popViewController(animated: true)
    }
    private func updateViews() {
        guard let gig = gig else { return }
        jobTitleTextField?.text = gig.title
        datePicker?.date = gig.dueDate
        textView?.text = gig.description
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
