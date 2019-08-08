//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Nathan Hedgeman on 8/7/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //Properties
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if gigController.bearer == nil {
            
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            
            gigController.getGigs()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSegue" {
            
            guard let loginVC = segue.destination as? LoginViewController else { return }
            
            loginVC.gigController = self.gigController
            
        }
            
    }
  

}
