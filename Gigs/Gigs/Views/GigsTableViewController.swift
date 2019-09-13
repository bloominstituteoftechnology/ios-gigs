//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Casualty on 9/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private var gigs: [String] = []
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    let loginViewModalSegue = "LoginViewModalSegue"
    let gigCell = "GigCell"
    let addGigSegue = "AddGigSegue"
    let showGigSegue = "ShowGigSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yy"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: loginViewModalSegue, sender: self)
        }
        gigController.fetchAllGigs { (result) in
            guard let success = try? result.get(),
                success else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginViewModalSegue {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }
        if segue.identifier == addGigSegue {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
        }
        if segue.identifier == showGigSegue {
            guard let detailVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gigController = gigController
            detailVC.gig = gigController.gigs[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: gigCell, for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let date = gigController.gigs[indexPath.row].dueDate
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        return cell
    }
}

