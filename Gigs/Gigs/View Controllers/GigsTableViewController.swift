//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Christopher Aronson on 5/9/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    // MARK: - Properties
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if gigController.bearer == nil {
            performSegue(withIdentifier: "ModalLoginViewController", sender: self)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let currentGig = gigController.gigs[indexPath.row]
        
        let df = DateFormatter()
        df.dateStyle = .short
        let date = df.string(from: currentGig.dueDate)

        cell.textLabel?.text = currentGig.title
        cell.detailTextLabel?.text = date
        

        return cell
    }

    // MARK: - prepare(for segue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalLoginViewController",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        }
        else if segue.identifier == "AddGig", let addVC = segue.destination as? GigsDetailViewController {
            addVC.gigController = gigController
        }
        else if segue.identifier == "ViewGig", let viewVC = segue.destination as? GigsDetailViewController {
            if let index = tableView.indexPathForSelectedRow {
                viewVC.gig = gigController.gigs[index.row]
            }
            
            viewVC.gigController = gigController
        }
    }

}
