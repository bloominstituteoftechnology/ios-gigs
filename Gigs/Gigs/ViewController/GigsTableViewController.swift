//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 3/11/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //
    //    @IBOutlet weak var gigTitleLabel: UILabel!
    //    @IBOutlet weak var dueDateLabel: UILabel!
    
    var gigController = GigController()
    var gig: Gig!
    let df = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            // TODO: fetch gigs here
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        df.dateStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else {
            if segue.identifier == "AddGigSegue" {
                if let addGigVC = segue.destination as? GigDetailViewController {
                    addGigVC.gigController = gigController
                    addGigVC.datePicker.date = gig.dueDate
                    addGigVC.jobTitleTextField.text = gig.title
                    addGigVC.jobDescriptionTextView.text = gig.description
                } else {
                    if segue.identifier == "ShowGigSegue" {
                        if let gigDetailVC = segue.destination as? GigDetailViewController {
                            gigDetailVC.gigController = gigController
                            gigDetailVC.datePicker.date = gig.dueDate
                            gigDetailVC.jobDescriptionTextView.text = gig.description
                            gigDetailVC.jobTitleTextField.text = gig.title
                        }
                    }
                }
            }
        }
    }
}
