//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 13/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDetail: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
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
