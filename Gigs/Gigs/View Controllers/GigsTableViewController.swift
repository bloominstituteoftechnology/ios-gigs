//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by morse on 5/9/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var allGigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGigs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let df = DateFormatter()
        df.dateStyle = .short
        cell.textLabel?.text = allGigs[indexPath.row].title
        cell.detailTextLabel?.text = df.string(from: allGigs[indexPath.row].dueDate)

        return cell
    }
    
    func fetchGigs() {
        gigController.fetchAllGigs { result in
            if let gigs = try? result.get() {
                DispatchQueue.main.async {
                    self.allGigs = gigs
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewGig" {
            if let gigVC = segue.destination as? GigDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    gigVC.gig = allGigs[indexPath.row]
                }
                gigVC.gigController = gigController
            }
        } else if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGig" {
            if let gigVC = segue.destination as? GigDetailViewController {
                gigVC.gigController = gigController
            }
        }
    }
    

}
