//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Taylor Lyles on 5/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
	
	let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if gigController.bearer == nil {
			performSegue(withIdentifier: "LoginModal", sender: self)
		}

    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return gigController.gigs.count
		
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
		let gig = gigController.gigs[indexPath.row]
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		let date = dateFormatter.string(from: gig.dueDate)
		
		cell.textLabel?.text = gig.title
		cell.detailTextLabel?.text = date
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "LoginModal",
			let loginVC = segue.destination as? LoginViewController {
			loginVC.gigController = gigController
		} else if segue.identifier == "AddGig",
			let addVC = segue.destination as? ViewController {
			addVC.gigController = gigController
		} else if segue.identifier == "ShowGig",
			let viewVC = segue.destination as? ViewController {
			if let index = tableView.indexPathForSelectedRow {
				viewVC.gig = gigController.gigs[index.row]
			}
			
			viewVC.gigController = gigController
		}
	}

  
}
