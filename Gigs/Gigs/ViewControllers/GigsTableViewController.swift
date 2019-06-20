//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit


class GigsTableViewController: UITableViewController {
	
	let gigController = GigController()
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if gigController.bearer == nil {
			performSegue(withIdentifier: "ShowSignUpSegue", sender: self)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	func getGigs() {
		
	}
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
		cell.textLabel?.text = gigController.gigs[indexPath.row].title
		cell.detailTextLabel?.text = gigController.df(date: gigController.gigs[indexPath.row].dueDate)
        

        return cell
    }

	
    // MARK: - Navigation

	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowSignUpSegue" {
			if let loginVC = segue.destination as? LoginViewController {
				loginVC.gigController = gigController
			}
		} else if segue.identifier == "ViewGigDetailSegue",
			let detailVC = segue.destination as? GigDetailViewController {
			if let indexPath = tableView.indexPathForSelectedRow {
				detailVC.gig = gigController.gigs[indexPath.row]
			}
			detailVC.gigController = gigController
		} else {
			if segue.identifier == "AddGigSegue" {
				if let detailVC = segue.destination as? GigDetailViewController {
					detailVC.gigController = gigController
				}
			}
		}
    }
}
