//
//  GigDetailViewController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/13/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionTV: UITextView!
    
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
