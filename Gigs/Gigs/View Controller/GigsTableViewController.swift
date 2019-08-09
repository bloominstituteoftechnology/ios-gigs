//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/7/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
	
	let gigController = GigController()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if gigController.bearer == nil {
			performSegue(withIdentifier: "LoginModalSegue", sender: nil)
		} else {
			gigController.gettingGigs { (error) in
				DispatchQueue.main.async {
				self.tableView.reloadData()
				}
			}
		}
	}
//
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let loginVC = segue.destination as? LoginViewController {
//			loginVC.gigController = gigController
//		}
//	}

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
		let gig = gigController.gigs[indexPath.row]
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		let date = dateFormatter.string(from: gig.dueDate)
		
		cell.textLabel?.text = gig.title
		cell.detailTextLabel?.text = date
		
		return cell
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "LoginModalSegue",
			let loginVC = segue.destination as? LoginViewController {
			loginVC.gigController = gigController
		} else if segue.identifier == "AddGigShowSegue",
			let addVC = segue.destination as? GigDetailViewController {
			addVC.gigController = gigController
		} else if segue.identifier == "ShowGigSegue",
			let viewVC = segue.destination as? GigDetailViewController {
			if let index = tableView.indexPathForSelectedRow {
				viewVC.gig = gigController.gigs[index.row]
			}
			
			viewVC.gigController = gigController
		}
	}


}
