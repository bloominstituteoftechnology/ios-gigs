//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Stephanie Ballard on 2/13/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gigDetailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
