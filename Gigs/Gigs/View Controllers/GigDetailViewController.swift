//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Nonye on 5/6/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    //MARK: - OUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - ACTIONS
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
