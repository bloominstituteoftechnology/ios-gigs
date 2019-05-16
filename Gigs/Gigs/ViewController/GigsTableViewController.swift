//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Kobe McKee on 5/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                
                do {
                    self.gigController.gigs = try result.get()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog("Error getting gigs")
                }      
            }
        
        }
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)

        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GigDetailSegue" {
            guard let destinationVC = segue.destination as? GigDetailViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            
            destinationVC.gig = gigController.gigs[index.row]
            destinationVC.gigController = gigController
            
        } else if segue.identifier == "NewGigSegue" {
            guard let destinationVC = segue.destination as? GigDetailViewController else { return }
            destinationVC.gigController = gigController
            
        } else if segue.identifier == "LoginSegue" {
            guard let destinationVC = segue.destination as? LoginViewController else { return }
            destinationVC.gigController = gigController
        }

    }

}
