//
//  GigsTableViewController.swift
//  iOS-Gigs
//
//  Created by Aaron Cleveland on 1/15/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let auth = Auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if auth.bearer == nil {
            performSegue(withIdentifier: "LoginViewSegue", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        // Configure the cell...

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.auth = auth
            }
        }
    }

}
