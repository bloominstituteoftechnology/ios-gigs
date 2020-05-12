//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Kenneth Jones on 5/10/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var formatter: DateFormatter = {
        let dFormatter = DateFormatter()
        dFormatter.dateStyle = .short
        dFormatter.timeStyle = .short
        return dFormatter
    }()
    
    let gigController = GigController()
    private var allGigs: [Gig] = [] {
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
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        // TODO: fetch gigs here
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.detailTextLabel?.text = formatter.string(from: gigController.gigs[indexPath.row].dueDate)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.gigController = gigController
                    detailVC.gig = gigController.gigs[indexPath.row]
                }
            }
        } else if segue.identifier == "AddGigSegue" {
            if let addVC = segue.destination as? GigDetailViewController {
                addVC.gigController = gigController
            }
        }
    }

}
