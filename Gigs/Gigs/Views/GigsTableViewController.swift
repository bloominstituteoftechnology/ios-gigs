//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Casualty on 9/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private var gigs: [String] = ["one","two"]
    let gigController = GigController()
    let LoginViewModalSegue = "LoginViewModalSegue"
    let GigCell = "GigCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForBearer()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GigCell, for: indexPath)
        cell.textLabel?.text = gigs[indexPath.row]
        cell.detailTextLabel?.text = "Available!"
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LoginViewModalSegue {
            if let destinationViewVC = segue.destination as? LoginViewController {
                destinationViewVC.gigController = gigController
            }
        }
    }
    
    func checkForBearer() {
        if gigController.bearer == nil {
            performSegue(withIdentifier: LoginViewModalSegue, sender: self)
        }
    }
}
