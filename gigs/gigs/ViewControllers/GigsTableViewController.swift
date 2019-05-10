//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if gigController.bearer == nil {
			performSegue(withIdentifier: "ModalySegue", sender: self)
		} else {
			fetchGigs()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return gigController.gigs.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
		let gig = gigController.gigs[indexPath.row]
		
		let datef = DateFormatter()
		datef.dateStyle = .medium
		
		cell.textLabel?.text = gig.title
		cell.detailTextLabel?.text = datef.string(from: gig.dueDate)
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ModalySegue" {
			guard let vc = segue.destination as? LoginViewController else { return }
			vc.gigController = gigController
		}
	}
	

	let gigController = GigController()
	var gigs: [Gig] = []
}


extension GigsTableViewController {
	
	func fetchGigs() {
		gigController.fetchGigs {
			result in
			
			guard let result = try? result.get() else {
				print("error fetchGigs()")
				return
			}
			
			DispatchQueue.main.async {
				self.gigs = result
				self.tableView.reloadData()
			}
		}
	}
	
	
}
