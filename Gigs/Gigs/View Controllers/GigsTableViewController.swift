//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/11/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "AuthenticateSegue", sender: self)
        } else {
            // TODO: fetch gigs here
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AuthenticateSegue" {
            guard let logInVC = segue.destination as? LoginViewController else { return }
            logInVC.gigController = gigController
        }
    }

}
