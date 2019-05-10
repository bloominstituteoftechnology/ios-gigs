//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
// MARK: - Table view data source
extension GigsTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
		return cell
	}
}
