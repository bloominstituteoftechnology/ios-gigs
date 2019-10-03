//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Isaac Lyons on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    //MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    }
}
