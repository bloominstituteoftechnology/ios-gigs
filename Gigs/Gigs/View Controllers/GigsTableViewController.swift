//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 13/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            self.performSegue(withIdentifier: "LoginSignupModalSegue", sender: nil)
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
        if segue.identifier == "LoginSignupModalSegue" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.gigController = gigController
            }
        }
    }
    
}
