//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

	
	@IBOutlet var gigTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	@IBOutlet var descriptionTextView: UITextView!
	
	var gigController: GigController!
	var gig: Gig?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
    
	@IBAction func saveButtonTaped(_ sender: UIBarButtonItem) {
		
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
