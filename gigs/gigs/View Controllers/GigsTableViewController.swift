//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Ian French on 5/10/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let reuseIdentifier = "GigCell"
    let gigController: GigController = GigController()
    let formatter = DateFormatter()
    private var gigNames: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            // TODO fetch Gigs
        } else {
            gigController.fetchAllGigs { (result) in
                do {
                    let fetchGig = try result.get()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }  catch {
                    print("Error fetching data")
                    
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gigTitle = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gigTitle.title
        cell.detailTextLabel?.text = formatter.string ( from: gigTitle.dueDate)
        
        
        return cell
    }
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController
            {
                loginVC.gigController = gigController
            }
            
            
        } else if segue.identifier == "ViewGigSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                if let gigIndex = tableView.indexPathForSelectedRow {
                    let detail = gigController.gigs[gigIndex.row]
                    detailVC.gig = detail
                    
                    detailVC.gigController = gigController
                }
            }
            
        } else if segue.identifier == "AddGigSegue"  {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        }
        
    }
    
}
