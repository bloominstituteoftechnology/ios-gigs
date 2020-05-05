//
//  GigsTableViewController.swift
//  IosGigs
//
//  Created by Kelson Hartle on 5/5/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    
    let gigController = GigController()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            
            performSegue(withIdentifier: "loginVCSegue", sender: self)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        if segue.identifier == "loginVCSegue" {
            
            if let loginVc = segue.destination as? LoginViewController {
                loginVc.gigController = gigController
            }
        }
        
    }
    

}
