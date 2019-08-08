//
//  GigDetailsVC.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/8/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GigDetailsVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var descriptionTextView: UITextView!
	
	//MARK: - Properties
	
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	//MARK: - IBActions
	
	@IBAction func saveBtnTapped(_ sender: Any) {
	}
	
	//MARK: - Helpers
	
	private func updateviews() {
		
	}
}
