//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Zack Larsen on 12/4/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private var jobPosting: [String] = []
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
        // Get the new view controller using segue.destination.
        
        // Set segue identifier or which segue.
        if segue.identifier == "LoginViewModalSegue" {
            
            // Set a destination
            // Cast the destination as where we're going i.e. to which viewController
            guard let loginVC = segue.destination as? LoginViewController else { return }
            
            // Pass what we need in the viewController
            loginVC.gigController = gigController
        }
    }
    

}
