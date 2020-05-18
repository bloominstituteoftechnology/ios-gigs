//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Ahava on 5/8/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        
        // TODO: fetch gigs here
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        let dateString = dateFormatter.string(from: gig.dueDate)
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "\(gig.dueDate)"
//        cell.detailTextLabel?.text = dateString

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        }
    }
    

}
