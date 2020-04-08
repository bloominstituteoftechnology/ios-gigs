//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/8/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
     // MARK: - Properties

    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigName: String?
    
    private lazy var viewModel = GigDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
