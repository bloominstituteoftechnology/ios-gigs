//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jorge Alvarez on 1/16/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("tapped Save")
        //print("ALL GIGS: \(gigController?.gigs)") // ?
        navigationController?.popViewController(animated: true)
    }
    
    var gigController: GigController?
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    // just in case
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    func updateViews() {
        guard let gig = gig else {return}
        print("\(gig)")
        titleTextField.text = gig.title
        datePicker.date = gig.dueDate
        textView.text = gig.description
        title = gig.title
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
