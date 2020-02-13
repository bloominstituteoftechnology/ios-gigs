//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
var gigController: GigController!
    
    @IBOutlet weak var titleField: UITextField!
        @IBOutlet weak var dueDatePicker: UIDatePicker!
        @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
@IBAction func saveTapped(_ sender: UIBarButtonItem) {
    
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
