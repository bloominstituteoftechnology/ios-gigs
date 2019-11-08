//
//  GigsTableViewController.swift
//  iosGigs
//
//  Created by denis cedeno on 11/5/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    var gigs:[Gig]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                if let gigs = try? result.get() {
                DispatchQueue.main.async {
                    self.gigs = gigs
                }
            }
        }
    }
    }
       

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gigTableViewCell", for: indexPath) as? GigsTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        let gig = gigController.gigs[indexPath.row]
        cell.gig = gig
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LoginViewModalSegue":
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        case "AddGigSegue":
                if let addVC = segue.destination as? GigDetailViewController {
                    addVC.gigController = gigController
            }
        case "ViewGigSegue":
                    
            guard let detailVC = segue.destination as? GigDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gigController = gigController
            detailVC.gig = gigController.gigs[indexPath.row]
    
            default:
            return
        }
    }

}

                
                
//        if segue.identifier == "LoginViewModalSegue" {
//            if let loginVC = segue.destination as? LoginViewController{
//                loginVC.gigController = gigController
//            } else if segue.identifier == "AddGigSegue" {
//                if let addVC = segue.destination as? GigDetailViewController{
//                    addVC.gigController = gigController
//                } else if segue.identifier == "ViewGigSegue" {
//
//                    guard let detailVC = segue.destination as? GigDetailViewController,
//                        let indexPath = tableView.indexPathForSelectedRow else { return }
//
//                    let gig = gigController.gigs[indexPath.row]
//                    detailVC.gigController = gigController
//                    detailVC.gig = gig
//
//                }
//            }
//        }
//    }
//
//
//}
