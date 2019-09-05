//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Percy Ngan on 9/4/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

	// MARK: - Properties

	let gigController = GigController()


	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if gigController.bearer == nil {
			performSegue(withIdentifier: "ToLoginModalSegue", sender: self)
		}
	}
	// TODO: Call the method that fetches all gigs from the API
	




	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

		// Configure the cell...

		return cell
	}


	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ToLoginModalSegue" {
			guard let destinationVC = segue.destination as? LoginViewController else { return }
			destinationVC.gigController = gigController

		}
	}

	
}
