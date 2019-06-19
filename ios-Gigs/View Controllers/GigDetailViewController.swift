 //
//  GigDetailViewController.swift
//  ios-Gigs
//
//  Created by Kat Milton on 6/19/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet var gigTitle: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var gigDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
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
