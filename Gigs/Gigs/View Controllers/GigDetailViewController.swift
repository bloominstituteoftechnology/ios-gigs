//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by David Wright on 1/23/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
