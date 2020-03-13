//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/12/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properites
    
    // TODO: Gross, why is this here?
    var gigController: GigController!
    var gigsTableView: GigsTableViewController?
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Actions

    @IBAction func saveButton(_ sender: Any) {
        if let title = titleTextField?.text,
            let date = datePicker?.date,
            let description = descriptionTextView?.text {
            
            let thisGig = Gig(title: title, description: description, dueDate: date)
            
            if gig == nil {
                // Create gig
                gigController.addGig(thisGig) { result in
                    DispatchQueue.main.async {
                        self.gigController.gigs.append(thisGig)
                        self.gigsTableView?.loadGigs()
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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if gig == nil {
            self.title = "New Gig"
        } else {
            self.title = gig?.title
        }
        
        updateViews()
    }
    
    func updateViews() {
        guard let gig = gig else { return }
        
        titleTextField?.text = gig.title
        datePicker?.date = gig.dueDate
        // FIXME: Control is hidden?!
        descriptionTextView?.text = gig.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
}
