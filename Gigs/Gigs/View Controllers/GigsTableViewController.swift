//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/21/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private let gigController = GigController()
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
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.fetchGigs { result in
                let theGigs = try? result.get()
                DispatchQueue.main.async {
                    self.gigs = theGigs
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        guard let gigs = gigs else { return UITableViewCell() }
        let gig = gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGig" {
            if let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let gigs = gigs,
                let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gig = gigs[indexPath.row]
                loginVC.gigController = gigController
            }
        }
        
    }
}
