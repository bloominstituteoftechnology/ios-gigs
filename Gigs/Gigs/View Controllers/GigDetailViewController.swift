//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by macbook on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK - Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
