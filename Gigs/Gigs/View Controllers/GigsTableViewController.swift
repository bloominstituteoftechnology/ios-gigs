//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var apiController = APIController()
    var gigController: GigController?
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            if gigController == nil {
                gigController = GigController(with: apiController)
                updateFromNetwork()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController?.gigs.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController?.gigs[indexPath.row]
        
        cell.textLabel?.text = gig?.title
        if let date = gig?.dueDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            
            loginVC.apiController = apiController
        } else if let detailVC = segue.destination as? GigDetailViewController {
            detailVC.gigController = gigController
            
            if segue.identifier == "ShowGigSegue" {
                guard let index = tableView.indexPathForSelectedRow?.row else { return }
                detailVC.gig = gigController?.gigs[index]
            }
        }
    }
    
    func updateFromNetwork() {
        gigController?.fetchGigsFromNetwork() { success in
            DispatchQueue.main.async {
                if !success {
                    let alert = UIAlertController(title: "Gig fetch failed.", message: "Please refer to console log for error details.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
