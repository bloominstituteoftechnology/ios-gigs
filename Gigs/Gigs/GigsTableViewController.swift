//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let gigController = GigController()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    private var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.fetchGigs { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("Failed fetching your gigs bruh")
                }
            }
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigTableViewCell", for: indexPath)
        
        let formattedDate = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = formattedDate
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
            else if segue.identifier == "ShowGigSegue" {
                guard let detailVC = segue.destination as? GigDetailViewController,
                    let indexPath = tableView.indexPathForSelectedRow else { return }
                detailVC.gigController = gigController
                detailVC.gig = gigController.gigs[indexPath.row]
            } else if segue.identifier == "AddGigSegue" {
                guard let addGigVC = segue.destination as? GigDetailViewController else { return }
                addGigVC.gigController = gigController
            }
        }
    }
}
