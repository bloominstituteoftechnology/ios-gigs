//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/17/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        letUserLoginIfNecessary()
        formatTheFormatter()
        tableView.reloadData()
    }
    
    //MARK: -Properties-
    
    var gigController = GigController()
    var dateFormatter = DateFormatter()
    
    
    //MARK: -Methods-
    
    func letUserLoginIfNecessary() {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        // TODO: fetch gigs here
    }
    
    func formatTheFormatter() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gigTitle = gigController.gigs[indexPath.row].title
        let dueDate = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.textLabel?.text = gigTitle
        cell.detailTextLabel?.text = dueDate
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            let loginVC = segue.destination as! LoginViewController
            loginVC.gigController = gigController
        } else if segue.identifier == "" {
            
        } else if segue.identifier == " " {
            
        }
    }
    
} //End of class
