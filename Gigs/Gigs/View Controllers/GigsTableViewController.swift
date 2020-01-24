//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by David Wright on 1/20/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    // MARK: - Properties
    
    var gigController = GigController()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    // MARK: - View Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            fetchGigs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Private Methods
    
    private func fetchGigs() {
        gigController.fetchAllGigs { error in
            if let error = error {
                print("Error fetching gigs: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "LoginViewModalSegue":
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
            
        case "AddGig":
            guard let gigDetailVC = segue.destination as? GigDetailViewController else { return }
            gigDetailVC.gigController = gigController
            
        case "ShowGig":
            guard let gigDetailVC = segue.destination as? GigDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard indexPath.row < gigController.gigs.count else { return }
            gigDetailVC.gigController = gigController
            gigDetailVC.gig = gigController.gigs[indexPath.row]
            
        default:
            return
        }
    }

}
