//
//  GigsTableViewController.swift
//  iOs-Gigs
//
//  Created by Sal Amer on 1/21/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    var gigs: [Gig]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginScreenSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                let listGigs = try? result.get()
                DispatchQueue.main.async {
                    self.gigs = listGigs
                    self.tableView.reloadData()
                }
            }
        }
        
        // TODO: fetch gigs here
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        // Configure the cell...

        guard let gigs = gigs else { return UITableViewCell() }
        let gig = gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        return cell
    }
 

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LoginScreenSegue" {
            //inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let loginVC = segue.destination as? GigDetailViewController {
                  loginVC.gigController = gigController
            }
        }
        else if segue.identifier == "ShowDetails" {
            if let indexPath = tableView.indexPathForSelectedRow,
            let gigs = gigs,
                let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gig = gigs[indexPath.row]
                loginVC.gigController = gigController
            }
        }
    }
 

}
