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

    // MARK: - Table view data source

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
        
        // TODO: set cell object
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            guard let loginViewController = segue.destination as? LoginViewController else {
                os_log("Invalid destination: %@", log: OSLog.default, type: .error, "\(segue.destination)")
                return
            }
            
            loginViewController.gigsController = controller
            loginViewController.loginDelegate = self
        }
    }
    
    func loginAuthenticated() {
        getAllGigs()
    }

}
