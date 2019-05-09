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
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

    // MARK: - prepare(for segue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalLoginViewController",
            let detailVC = segue.destination as? LoginViewController {
            detailVC.gigController = gigController
        }
        else if segue.identifier == "LoginViewModalSegue" {
            
        }
    }

}
