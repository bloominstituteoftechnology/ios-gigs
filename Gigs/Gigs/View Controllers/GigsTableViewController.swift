//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jonathan Ferrer on 5/16/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.getAllGigs { (result) in

                do{
                    self.gigController.gigs = try result.get()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                NSLog("Errror getting all gigs")
            }
        }
        }
    }
    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            let destinationVC = segue.destination as! LoginViewController
            destinationVC.gigController = self.gigController
        }else if segue.identifier == "ShowGig" {
            let destinationVC = segue.destination as! GigDetailViewController
            destinationVC.gigController = self.gigController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.gig = gigController.gigs[indexPath.row]
        }else if segue.identifier == "AddGig" {
            let destinationVC = segue.destination as! GigDetailViewController
            destinationVC.gigController = self.gigController
            
        }
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]

        cell.textLabel?.text = gig.title
        let df = DateFormatter()
        df.dateStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)

        return cell
    }




}
