//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/5/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitle: UITextField!
    
    @IBOutlet weak var dueDate: UIDatePicker!
    
    @IBOutlet weak var jobDescription: UITextView!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
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
