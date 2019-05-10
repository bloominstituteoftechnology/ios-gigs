//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

	let gigController = GigController()
	let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if gigController.bearer == nil {
			performSegue(withIdentifier: "ShowLoginVC", sender: self)
		} else {
			loadData()
		}
	}

	func loadData() {
		gigController.getAllGigs { [weak self] (error) in
			if let error = error {
				let alertVC = UIAlertController(error: error, preferredStyle: .alert)
				DispatchQueue.main.async {
					self?.present(alertVC, animated: true)
				}
			}
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if let dest = segue.destination as? LoginViewController {
			if segue.identifier == "ShowLoginVC" {
				dest.gigController = gigController
			}
		} else if let dest = segue.destination as? GigDetailViewController {
			dest.gigController = gigController
			if segue.identifier == "CreateGigDetail" {
				// dont need anything else right now
			} else if segue.identifier == "ShowGigDetail" {
				guard let indexPath = tableView.indexPathForSelectedRow else { return }
				let gig = gigController.gigs[indexPath.row]
				dest.gig = gig
			}

		}
	}
}
// MARK: - Table view data source
extension GigsTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return gigController.gigs.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

		let gig = gigController.gigs[indexPath.row]

		cell.textLabel?.text = gig.title
		cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)

		return cell
	}
}
