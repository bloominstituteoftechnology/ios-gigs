//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            return
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


