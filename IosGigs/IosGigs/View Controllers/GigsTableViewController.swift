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
        } else {
            gigController.getGigs { result in
                if let gig = try? result.get() {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    let df = DateFormatter()
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobListCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        //cell.detailTextLabel?.text = "Due: \(gig.dueDate.description.prefix(9))"
       // df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        df.dateStyle = .short
        let finalDateString = df.string(from: gig.dueDate)
        cell.detailTextLabel?.text = "Due: \(finalDateString)"

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
        else if segue.identifier == "AddGig" {
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController
            }
            
        }
        else if segue.identifier == "ViewGig" {
            if let gigDetailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                gigDetailVC.gigController = gigController
                gigDetailVC.gig = gigController.gigs[indexPath.row]
            }
        }
        
    }
    

}
