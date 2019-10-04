//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var gigs: [Gig] = []
    let gigController = GigController()
    var gig: Gig!
    
    let formatter = DateFormatter()
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { ( error ) in
                if let error = error {
                    NSLog("Error \(error)")
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
            }
            //TODO: fetch gigs here
        }
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        formatter.dateStyle = .short
        cell.detailTextLabel?.text = formatter.string(from: gig.dueDate )
        cell.textLabel?.text = gig.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGig" {
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGig" {
            if let showGigVC = segue.destination as? GigDetailViewController {
                showGigVC.gigController = gigController
            }
        }
    }
}

