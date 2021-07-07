//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/12/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Propeties
    
    let gigController = GigController()
    
    
    
    // MARK: - Methods
    
    func gigDateFormatter(gig: Gig) -> String{
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateString = dateFormatter.string(from: gig.dueDate)
        return dateString
    }
    
    private func getGigs(){
        gigController.fetchGigs { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGigs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
            
        } else {
            getGigs()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = gigDateFormatter(gig: gig)
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            guard let loginVC = segue.destination as? LogInViewController else { return }
            loginVC.gigController = gigController
        } else if segue.identifier == "AddGigSegue" {
            guard let addVC = segue.destination as? GigDetailViewController else { return }
            addVC.gigController = gigController
        } else if segue.identifier == "ShowGigSegue" {
            guard let gigDetailVC = segue.destination as?
                GigDetailViewController,
                let indexpath = tableView.indexPathForSelectedRow else { return }
            gigDetailVC.gigController = gigController
            gigDetailVC.gig = gigController.gigs[indexpath.row]
        }
    }
}
