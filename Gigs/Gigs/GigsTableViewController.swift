//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Josh Kocsis on 5/8/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let reuseIdentifier = "GigsCell"
    let gigController: GigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoggingSegue", sender: self)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        
        
        return cell
    }
}
