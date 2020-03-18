//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Juan M Mariscal on 3/17/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    private let gigController = GigController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginVCModalSegue", sender: self)
        }
        // TODO: fetch gigs here
     
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginVCModalSegue",
            let loginVC = segue.destination as? LoginViewController {
            // inject dependencies
            loginVC.gigController = gigController
        }
    }

}
