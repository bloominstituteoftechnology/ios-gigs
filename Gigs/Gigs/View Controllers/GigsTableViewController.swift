//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/11/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "AuthenticateSegue", sender: self)
        } else {
            // TODO: fetch gigs here
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = formatDate(for: gig.dueDate)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AuthenticateSegue" {
            guard let logInVC = segue.destination as? LoginViewController else { return }
            logInVC.gigController = gigController
        }
    }

    // MARK: - Methods
    private func formatDate(for date: Date) -> String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
}
