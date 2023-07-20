//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 13.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var dueDP: UIDatePicker!
    @IBOutlet weak var descriptionTV: UITextView!
    
    // MARK: - Properties
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return }
        title = gig.title
        jobTitleTF.text = gig.title
        dueDP.date = gig.dueDate
        descriptionTV.text = gig.description
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        guard let title = jobTitleTF.text,
            let description = descriptionTV.text else { return }
        
        let gig = Gig(title: title, dueDate: dueDP.date, description: description)
        
        gigController.createGig(with: gig) { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
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

}
