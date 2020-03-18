//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    // MARK: - Properties
    var gigController = GigController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "PresentLoginSegue", sender: self)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentLoginSegue", let loginVC = segue.destination as? LoginViewController {
            //dependency injection
            loginVC.gigController = gigController
        }
    }


}
