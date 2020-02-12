//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/12/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    //MARK: Properties
    let gigController = GigController()
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          // transition to login view if conditions require
          if gigController.bearer == nil {
              performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
          }
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

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
        // inject dependencies
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
            }
        }
    }


}
