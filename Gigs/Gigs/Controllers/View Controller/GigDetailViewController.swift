//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 16/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
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
