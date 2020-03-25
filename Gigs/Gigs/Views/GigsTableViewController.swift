//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/10/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "segueSignIn", sender: self)
        }
        
        gigController.getAllGigs { (error) in
            if let _ = error {
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as? GigsTableViewCell else {
            return UITableViewCell()
        }
        
        let theGig = gigController.gigs[indexPath.row]
        
        cell.lblGig.text = theGig.title
        cell.lblGigDueDate.text = "Due \(dateFormatter.string(from: theGig.dueDate))"
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSignIn" {
            if let vc = segue.destination as? SignInViewController {
                vc.gigController = self.gigController
            }
        } else {
            if let vc = segue.destination as? GigDetailViewController {
                vc.gigController = gigController
                if segue.identifier == "ShowGigSegue" {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        vc.gig = gigController.gigs[indexPath.row]
                    }
                }
            }
        }
    }
}
