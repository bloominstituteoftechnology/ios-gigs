//
//  GigDetailViewController.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/3/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var gigTitleTextField: UITextField!
    @IBOutlet var gigDatePicker: UIDatePicker!
    @IBOutlet var gigInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//MARK: Actions
    @IBAction func saveGigButtonTapped(_ sender: UIBarButtonItem) {
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
