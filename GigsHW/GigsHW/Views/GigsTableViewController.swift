//
//  GigsTableViewController.swift
//  GigsHW
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gc = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gc.bearer == nil {
            //this means we have not signed in otherwise we would have our token
            performSegue(withIdentifier: "LogInSegue", sender: self)
        } else {
            gc.fetchAllGigs { (result) in
                if let gigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gc.gigs = gigs
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gc.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let gig = gc.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let df = DateFormatter()
        df.dateStyle = .short
        
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInSegue" {
            guard let destinationVc = segue.destination as? LoginViewController else { return }
            destinationVc.gc = gc
        }
        
        if segue.identifier == "AddSegue" {
            guard let destinationVc = segue.destination as? NewGigsViewController else { return }
            destinationVc.gc = gc
        }
        
        if segue.identifier == "CellSegue" {
            guard let destinationVc = segue.destination as? NewGigsViewController, let index = tableView.indexPathForSelectedRow else { return }
            let gigToPass = gc.gigs[index.row]
            destinationVc.gig = gigToPass
            destinationVc.gc = gc
        }
    }
  

}
