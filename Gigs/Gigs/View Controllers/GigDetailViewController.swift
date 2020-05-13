//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/13/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var gigName: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescription: UITextView!
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Properties
    // TODO

    override func viewDidLoad() {
        super.viewDidLoad()
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
