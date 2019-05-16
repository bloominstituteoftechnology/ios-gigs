//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Mitchell Budge on 5/16/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    var gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()

    } // end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            gigController.getGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    } // end of view will appear

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    } // end of number of rows

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    } // end of cell for row at

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
}
