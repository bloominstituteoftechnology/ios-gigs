//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Enrique Gongora on 2/12/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //MARK: - Variables
    var gigController = GigController()
    
    //MARK: - DateFormatter
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignUpSegue", sender: self)
        }
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            if let signUpVC = segue.destination as? LoginViewController {
                signUpVC.gigController = gigController
            }
        }
    }
}
