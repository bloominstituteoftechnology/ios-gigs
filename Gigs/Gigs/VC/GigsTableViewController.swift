//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Lydia Zhang on 3/11/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignUpSegue", sender: self)
        } else {
            gigController.fetchGigs{ result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GIGSCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        let time = df.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = time
        return cell
    }
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SignUpSegue":
            guard let signUpVC = segue.destination as? LoginViewController else {return}
            signUpVC.gigController = gigController
        
        case "AddSegue":
            guard let addVC = segue.destination as? GigDetailViewController else {return}
            addVC.gigController = gigController
            
        case "ShowGigsCellSegue":
            guard let detailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            detailVC.gigController = gigController
            detailVC.gigs = gigController.gigs[indexPath.row]
            
        default:
            return
        }
    }
}
