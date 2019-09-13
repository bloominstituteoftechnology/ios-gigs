//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Dillon P on 9/10/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    let dateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignUpLoginModalSegue", sender: self)
        } else {
            // TODO: fetch gigs here
            gigController.fetchAllGigs { (result) in
                if let _ = try? result.get() {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        
        if let titleLabel = cell.textLabel, let detailLabel = cell.detailTextLabel {
            titleLabel.text = gig.title
            dateFormatter.dateStyle = .short
            detailLabel.text = dateFormatter.string(from: gig.dueDate)
        }

        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpLoginModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }
  

}
