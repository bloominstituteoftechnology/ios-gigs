//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jordan Christensen on 9/6/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateViews() {
        guard isViewLoaded, let gig = gig else { return }
        titleTextField.text = gig.title
//        gigDatePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
    }
    
    func setUI() {
        view.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let gigController = gigController, let title = titleTextField.text,
            let desc = descriptionTextView.text else { return }
        
        gigController.createGig(with: Gig(dueDate: dateFormatter.string(from: gigDatePicker.date), description: desc, title: title), completion: { (networkError) in
            if let error = networkError {
                NSLog("An error occurred saving the gig to the server: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
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
