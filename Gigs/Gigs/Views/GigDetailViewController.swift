//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/7/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        
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
