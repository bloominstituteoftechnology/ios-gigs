//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    var gig: Gig?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    func updateViews() {
          if let gig = gig {
          titleField.text = gig.title
          dueDatePicker.date = gig.dueDate
          descriptionView.text = gig.description
       } else {
      title = "New Gig"
      descriptionView.text = ""
    }
 }
    
@IBAction func saveTapped(_ sender: UIBarButtonItem) {
    
    guard let titleText = titleField.text,
        !titleText.isEmpty,
        let descriptionText = descriptionView.text,
        !descriptionText.isEmpty else {
            return
    }
    let gig = Gig(title: titleText, dueDate: dueDatePicker.date, description: descriptionText)

        gigController?.createGig(with: gig, completion: { (result) in
         DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: true)
        }
      })
    }
  }
