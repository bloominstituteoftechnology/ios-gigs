//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Ian French on 5/10/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let reuseIdentifier = "GigCell"
    let gigController: GigController = GigController()
    private var gigNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          // transition to login view if conditions require
          if gigController.bearer == nil {
              performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            // TODO fetch Gigs
          }
      }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigNames.count
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

          // Configure the cell...
          cell.textLabel?.text = gigNames[indexPath.row]

          return cell
      }

   
   


    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "LoginViewModalSegue" {
                if let loginVC = segue.destination as? LoginViewController
                {
                loginVC.gigController = gigController
                }
            }
        }
    
}

