//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Elizabeth Thomas on 3/17/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Public Properties
    let gigController = GigController()
    
    // MARK: - Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
       // TODO: fetch gigs here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
   
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        }
    }

}
