//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Kobe McKee on 5/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    
    @IBAction func saveJobButtonPressed(_ sender: Any) {
    }
    
    
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
