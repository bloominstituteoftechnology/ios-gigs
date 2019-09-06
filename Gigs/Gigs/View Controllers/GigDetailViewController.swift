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

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = "title textField"
        descriptionTextView.text = "desc textView"
        
        setUI()
        
        if let _ = gig {
            updateViews()
        }
    }
    
    var gig: Gig?
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateViews() {
        guard let gig = gig else { return }
        self.title = gig.title
        titleTextField.text = gig.title
//        gigDatePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
    }
    
    func setUI() {
        view.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        titleTextField.backgroundColor = UIColor(red: 0.40, green: 0.41, blue: 0.39, alpha: 1.00)
        descriptionTextView.backgroundColor =  UIColor(red: 0.40, green: 0.41, blue: 0.39, alpha: 1.00)
        gigDatePicker.setValue(UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00), forKeyPath: "textColor")
        
        descriptionTextView.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        titleTextField.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        titleTextField.attributedPlaceholder = NSAttributedString(string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.78, green: 0.76, blue :0.76, alpha: 1.00)])
        
        descriptionLabel.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        dateLabel.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        jobTitleLabel.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3).cgColor
        descriptionTextView.layer.cornerRadius = 8
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
