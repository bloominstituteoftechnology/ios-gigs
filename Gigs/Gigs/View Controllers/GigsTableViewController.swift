//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
  let gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        // TODO: fetch gigs here
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "LoginViewModalSegue" {
              guard let loginVC = segue.destination as? LoginViewController else { return }
                  loginVC.gigController = gigController
          }
     }
}
