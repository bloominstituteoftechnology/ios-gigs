//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by David Williams on 3/17/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigcontroller = GigController()
    private var gigs: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        if gigcontroller.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            // TODO: fetch gigs here
        }
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)

        cell.textLabel?.text = gigs[indexPath.row]
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigcontroller
        }
    }
}
