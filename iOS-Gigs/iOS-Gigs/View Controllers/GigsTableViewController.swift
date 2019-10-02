//
//  GigsTableViewController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/2/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var gigController = GigController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            // TODO: Fetch gigs here
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }
}
