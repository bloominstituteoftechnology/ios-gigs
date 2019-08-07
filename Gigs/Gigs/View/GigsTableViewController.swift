//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/7/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "LoginModalSegue" {
			if let loginVC = segue.destination as? LoginViewController {
				
			}
		}
	}

}
