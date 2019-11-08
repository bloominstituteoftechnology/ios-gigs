//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/4/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    private var gigs: [Gig] = []
    let gigController = GigController()
    var date: DateFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { result in
                if let arrayOfGigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigs = arrayOfGigs
                        self.tableView.reloadData()
                    }
                }
            }
        }
       
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = gigs[indexPath.row].title
        cell.detailTextLabel?.text = gigs[indexPath.row].dueDate.description
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
           case "ShowGigDetailsSegue":
               
               guard let detailVC = segue.destination as? GigDetailViewController,
                   let indexPath = tableView.indexPathForSelectedRow else { return }
               detailVC.gigController = gigController
               detailVC.gig = gigController.gigs[indexPath.row]
               
           default:
               return
           }
       }
}
