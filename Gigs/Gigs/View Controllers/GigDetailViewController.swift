//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/12/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescription: UITextView!
    
    
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

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}
