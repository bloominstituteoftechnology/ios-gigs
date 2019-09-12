//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bobby Keffury on 9/12/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    
    
    //MARK: - Views

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
    
    //MARK: - Methods
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    

}
