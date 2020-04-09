//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/8/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
     // MARK: - Properties

    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigName: String?
    
    private lazy var viewModel = GigDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let gigName = gigName else { return }
        
        viewModel.getGig(with: gigName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .successfulWithGig(let gig):
                self.updateViews(with: gig)
            case .failure(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
            }
        }
    }
    
    private func updateViews(with gig: Gig) {
        title = gig.title
        jobTextField.text = gig.title
        datePicker.date = gig.dueDate
        jobDescriptionTextView.text = gig.description
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
    }
 

}
