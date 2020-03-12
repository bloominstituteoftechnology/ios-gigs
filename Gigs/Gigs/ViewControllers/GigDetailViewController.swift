//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/12/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // MARK: - IBActions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        createGig()
    }
    
    // MARK: - Public Properties
    
    var gig: Gig? { didSet { self.navigationItem.rightBarButtonItem = nil }}
    var gigController: GigController?
    
    
    // MARK: - Private
    
    private func createGig() {
        let date = datePicker.date
        guard let title = jobTitleTextField.text,
            let description = descriptionTextView.text else { return }
        
        gigController?.createGig(title: title, dueDate: date, description: description) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    NSLog("Couldn't create gig: \(error)")
                }
            }
            
        }
    }
    
    private func updateViews() {
        guard let gig = gig else { return }
        jobTitleTextField.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
}
