//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/7/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

// delegate and data source
class GigsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var gigCongroller = GigController()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if GigController.bearer == nil {
            performSegue(withIdentifier: "loginViewController", sender: self)
        } else {
            gigCongroller.getGigs { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("Failed to fetch gigs")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginViewController" {
            guard let loginViewController = segue.destination as? LoginViewController else { return }
            
            loginViewController.gigController = gigCongroller
        } else if segue.identifier == "ShowGig" {
            guard let detailViewController = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailViewController.gigController = gigCongroller
            detailViewController.gig = gigCongroller.gigs[indexPath.row]
        } else if segue.identifier == "AddGig" {
            guard let detailViewController = segue.destination as? GigDetailViewController else { return }
            detailViewController.gigController = gigCongroller
        }
    }
    
    
    
    
    
    
}

extension GigsTableViewController {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigCongroller.gigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        cell.textLabel?.text = gigCongroller.gigs[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigCongroller.gigs[indexPath.row].dueDate)
        return cell
    }
}
