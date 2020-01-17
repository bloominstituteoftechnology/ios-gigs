//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    //MARK: Class Properties
    var gigController = GigController()
    var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let customNavBarAppearance = NavBarAppearance.appearance()
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: fetch gigs here
        if !gigController.isUserLoggedIn {
            self.performSegue(withIdentifier: "SignInSegue", sender: self)
        } else if gigs.count == 0 {
            gigController.getAllGigs { (error) in
                print("done")
                DispatchQueue.main.async {
                    self.gigs = self.gigController.gigs
                }
                
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        let date = df.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = date
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let destination = segue.destination as? LoginViewController else {return}
            destination.gigController = gigController
        } else if segue.identifier == "ShowGig" {
            guard let destination = segue.destination as? GigDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.gig = gigs[indexPath.row]
        } else if segue.identifier == "AddGig" {
            guard let destination = segue.destination as? GigDetailViewController else {return}
            destination.gigController = gigController
        }
        
    }

}
