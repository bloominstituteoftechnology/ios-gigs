//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Clean Mac on 5/14/20.
//  Copyright © 2020 LambdaStudent. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let reuseIdentifier = "gigsTableViewCell"
    let apiController = APIController()
    private var gigs: [Gig] = []
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            apiController.fetchAllGigs{ (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let gigs = apiController.gigs[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = gigs.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigs.dueDate)
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        else if segue.identifier == "createGig" {
            if let createGigVC = segue.destination as? GigDetailViewController{
                createGigVC.apiController = apiController
            }
        }
        else if segue.identifier == "showGig" {
            if let viewGig = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow{
                viewGig.apiController = apiController
                viewGig.gig = apiController.gigs[indexPath.row]
            }
        }
        
        
    }
    
    

}
