//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Dennis Rudolph on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    var df: DateFormatter {
        let dF = DateFormatter()
        dF.dateStyle = .short
        return dF
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogSignSegue", sender: self)
        } else {
            gigController.fetchAllGigs { result in
                <#code#>
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = df.string(from: gigController.gigs[indexPath.row].dueDate)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogSignSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }
}
