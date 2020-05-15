//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/9/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController: GigController = GigController()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ToLogInScreen", sender: self)
        } else {
            gigController.fetchGig { (result) in
                do {
                    let success = try result.get()
                    if success {
                        DispatchQueue.main.async {
                            print("Successfully fetched all gigs")
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Unable to create new gig with \(error)")
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
        let gigName = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gigName.title
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.detailTextLabel?.text = formatter.string(from: gigName.dueDate)
        //  cell.textLabel?.text = gigNames[indexPath.row]
        
        return cell
    }
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLogInScreen" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        if segue.identifier == "AddGig" {
            if let gigDetail = segue.destination as? GigDetailViewController {
                gigDetail.gigController = gigController
            }
        }
        if segue.identifier == "ShowGig" {
            guard let showGig = segue.destination as? GigDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            showGig.gig = gigController.gigs[indexPath.row]
            showGig.gigController = gigController
        }
    }
}



