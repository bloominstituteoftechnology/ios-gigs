//
//  GigsTableViewController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let gigController = GigController()
    var df = DateFormatter()

    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "tableToLogin", sender: self)
        }
        // TODO: fetch gigs here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        return cell
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToLogin" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }
        else if segue.identifier == "addToAddDetail" {
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController
            }
        }   else if segue.identifier == "cellToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
            let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gig = gigController.gigs[indexPath.row]
            loginVC.gigController = gigController
            
            }
                
            
    

}
}
}
