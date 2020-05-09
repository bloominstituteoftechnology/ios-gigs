//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/9/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    
    var gigNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ToLogInScreen", sender: self)
        }
        
        // TODO: fetch gigs here
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        cell.textLabel?.text = gigNames[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLogInScreen" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }
    
    
}
