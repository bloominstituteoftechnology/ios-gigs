//
//  GigDetailViewController.swift
//  iOS Gigs
//
//  Created by Brandi on 10/31/19.
//  Copyright © 2019 Brandi. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigTitle: UITextField!
    @IBOutlet weak var gigDueDate: UIDatePicker!
    @IBOutlet weak var gigDesc: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gigSaveButton(_ sender: Any) {
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
