//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/5/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import os.log

class GigsTableViewController: UITableViewController, LoginDelegate {
    
    let controller = GigController()
    
    var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if controller.bearer == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func loginAuthenticated() {
        getAllGigs()
    }
    

    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gigsViewCell", for: indexPath) as? GigsTableViewCell else {
            os_log("The dequeued cell is not being displayed by the table", log: OSLog.default, type: .error)
            
            let errorCell = GigsTableViewCell()
            errorCell.gigTitleLabel.text = "Error"
            errorCell.dateLabel.text = "Error"
            
            return errorCell
        }
        
        let selectedGig = gigs[indexPath.row]
        cell.gig = selectedGig
                
        return cell
    }
    
    @objc func refreshTable(_ sender: Any) {
        getAllGigs()
        self.refreshControl?.endRefreshing()
    }
    
    func getAllGigs() {
        controller.getAllGigs { result in
            do {
                let receivedGigs = try result.get()
                DispatchQueue.main.async {
                    self.gigs = receivedGigs
                }
            } catch {
                if let error = error as? GigController.NetworkError {
                    switch error {
                    case .noToken:
                        os_log("Token authorization missing or invalid", log: OSLog.default, type: .error)
                    case .noData, .tryAgain:
                        os_log("No data received from server. Try calling again?", log: OSLog.default, type: .error)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    // MARK: - Storyboard Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
        case "loginSegue":
            guard let loginViewController = segue.destination as? LoginViewController else {
                os_log("Invalid destination: %@", log: OSLog.default, type: .error, "\(segue.destination)")
                return
            }
            
            loginViewController.gigsController = controller
            loginViewController.loginDelegate = self
            
        case "showDetailSegue":
            guard let gigDetailViewController = segue.destination as? GigDetailViewController else {
                os_log("Invalid destination: %@", log: OSLog.default, type: .error, "\(segue.destination)")
                return
            }
            
            guard let selectedCell = sender as? GigsTableViewCell else {
                os_log("Unexpected sender: %@", log: OSLog.default, type: .error, "\(sender ?? "No sender available")")
                return
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                os_log("The selected cell is not being displayed by the table view", log: OSLog.default, type: .error)
                return
            }
            
            gigDetailViewController.gig = gigs[indexPath.row]
            
        case "addGigSegue":
            os_log("Add button pressed")
            
        default:
            os_log("Invalid segue or no segue identifier available", log: OSLog.default, type: .error)
        }
    }
    
    @IBAction func unwindToGigsTableView(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GigDetailViewController, let sourceGig = sourceViewController.gig {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                gigs[selectedIndexPath.row] = sourceGig
                tableView.reloadData()
                
            } else {
                controller.createGig(with: sourceGig) { result in
                    
                    do {
                        let success = try result.get()
                        if success {
                            os_log("Successfully posted a new gig to server")
                            
                            DispatchQueue.main.async {
                                self.gigs.append(sourceGig)
                                self.tableView.reloadData()
                            }
                        }
                        
                    } catch {
                        os_log("Error while posting new gig to server", log: OSLog.default, type: .error)
                        return
                    }
                }
            }
        }
    }

}
