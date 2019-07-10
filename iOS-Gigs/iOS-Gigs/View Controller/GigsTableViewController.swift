//
//  GigsTableViewController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var gigController = GigController()
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.fetchGigs { (result) in
                
                do {
                    self.gigController.gigs = try result.get()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog("Error fetching gigs")
                }
            }
        }
    }
    
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        df.dateStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)

        return cell
    }
    

   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
            if segue.identifier == "AddGig" {
                guard let addGigVC = segue.destination as? GigDetailViewController else { return }
                addGigVC.gigController = gigController
            }
            if segue.identifier == "ShowGig" {
                guard let showGigVC = segue.destination as? GigDetailViewController,
                    let index = tableView.indexPathForSelectedRow else { return }
                let shownGig = gigController.gigs[index.row]
                showGigVC.gigController = gigController
                showGigVC.gig = shownGig
            }
        }
    }
    

}
