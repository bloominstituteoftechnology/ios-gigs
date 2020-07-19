//
//  GigDetailViewController.swift
//  gigsCraigBelinfante
//
//  Created by Craig Belinfante on 7/18/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var apiController: APIController?
    var gig: String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var saved: UIBarButtonItem!
    @IBAction func saveButton(_ sender: UIButton) {
         //(UIViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func newGig() {
        guard let apiController = apiController,
        let gig = gig else { return }
        apiController.getAllGigs { (result) in
            switch result {
            case .success(let gig):
                DispatchQueue.main.async {
                    //self.updateViews(with: gig)
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateViews(with allGig: Gig) {
        title = "Create Gig"
        descriptionField.text = allGig.description
        textField.text = allGig.title
    }
    
}
