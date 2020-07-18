//
//  GigsTableViewController.swift
//  iosGigsProject
//
//  Created by B$hady on 7/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigControlla = GigController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigControlla.bearer == nil {
            performSegue(withIdentifier: "signUpSegue", sender: self)
        } else {
            // TODO: fetch gigs here
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)


           return cell
       }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigControlla
            }
        }
    }
}
