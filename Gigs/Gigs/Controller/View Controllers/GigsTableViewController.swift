//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    let authController = AuthenticationController()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if authController.bearer == nil {
            performSegue(withIdentifier: "ShowLoginSegue", sender: self)
        } else {
            fetchGigs()
        }
    }
    
    private func fetchGigs() {
        authController.fetchAllGigs { error in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowLoginSegue":
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.authController = authController
        case "ShowGigsSegue":
            guard let gigDetailVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            gigDetailVC.authController = authController
            gigDetailVC.gig = self.authController.gigs[indexPath.row]
        case "AddGigsSegue":
            guard let gigDetailVC = segue.destination as? GigDetailViewController else { return }
            gigDetailVC.authController = authController
        default:
            break
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = authController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    }
}
