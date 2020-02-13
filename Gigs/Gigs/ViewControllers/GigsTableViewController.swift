//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/12/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Propeties
    
    let gigController = GigController()
    
    
    
    // MARK: - Methods
    
    func gigDateFormatter(gig: Gig) -> String{
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateString = dateFormatter.string(from: gig.dueDate)
        return dateString
    }
    
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gigController.fetchGigs { (result) in
            
            do{
                let gigs = try result.get()
                DispatchQueue.main.async {
                    self.gigController.gigs = gigs
                    self.tableView.reloadData()
                }
            } catch {
                
            }
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        // TODO: fetch gigs here
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
        cell.textLabel?.text = gig.description
        cell.detailTextLabel?.text = gigDateFormatter(gig: gig)
        return cell
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            guard let loginVC = segue.destination as? LogInViewController else { return }
                loginVC.gigController = gigController
        }
    }
}
