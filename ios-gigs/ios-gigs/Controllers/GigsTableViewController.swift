//
//  GigsTableViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class GigsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    let gigController = GigController()
    var delegate: User?
    //    var gigs: [Gig] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let loginVC = LoginViewController()
        loginVC.delegate = self
        if gigController.bearer == nil {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gigController.fetchGigs { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        
        if segue.identifier == "AddGig" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        }
        
        if segue.identifier == "GigDetail" {
            if let detailVC = segue.destination as? GigDetailViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else {return}
                let gig = gigController.gigs[indexPath.row]
                detailVC.detailGig = gig
                detailVC.gigController = gigController
            }
        }
    }
}

extension GigsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        
        return cell
    }
}

extension GigsTableViewController: loginViewControllerDelegate {
    func loginSucessful(_ loginWasASuccess: Bool) {
        if loginWasASuccess {
            gigController.fetchGigs { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
