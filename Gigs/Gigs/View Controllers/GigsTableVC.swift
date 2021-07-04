//
//  GigsTableVC.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/7/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GigsTableVC: UITableViewController {
	
	//MARK: - IBOutlets
	
	
	//MARK: - Properties
	
	var gigController: GigController?
	private var gigs: [Gig] {
		guard let gigs = gigController?.gigs else { return [Gig]() }
		return gigs
	}
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		gigController = GigController()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if gigController?.bearer == nil {
			performSegue(withIdentifier: "LoginVCModalSegue", sender: nil)
		} else {
			fetchGigs()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let loginVC = segue.destination as? LoginVC {
			loginVC.gigController = gigController
		} else if let gigDetailsVC = segue.destination as? GigDetailsVC {
			if segue.identifier == "ShowExistingGigSegue", let indexPath = tableView.indexPathForSelectedRow {
				gigDetailsVC.gigToDisplay = gigs[indexPath.row]
			}
			gigDetailsVC.gigController = gigController
		}
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func fetchGigs() {
		gigController?.getAllGigs(completion: { (result) in
			guard let _ = try? result.get() else { return }
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		})
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigs[indexPath.row]
		
		cell.textLabel?.text = gig.title
		cell.detailTextLabel?.text = "Due: \(dateFormatter.string(from: gig.dueDate))"

        return cell
    }
}
