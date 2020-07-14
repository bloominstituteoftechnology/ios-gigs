//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Norlan Tibanear on 7/10/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    
    var gigsController = GigsController()

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigsController.bearer == nil {
            performSegue(withIdentifier: "LoginVCSegue", sender: self)
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigsController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = gigsController.gigs[indexPath.row].title

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginVCSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigsController = gigsController
            }
        }
    }
    

    

} //
