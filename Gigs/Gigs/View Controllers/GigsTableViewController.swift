//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 6/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //
    //MARK: - Properties
    //
    
    let gigController = GigController()
    
    //
    //MARK: - View LifeCycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogInModalSegue", sender: self)
        }
    }
    
    //
    // MARK: - Table view data source
    //


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        return cell
    }

    //
    // MARK: - Navigation
    //
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }
    

}
