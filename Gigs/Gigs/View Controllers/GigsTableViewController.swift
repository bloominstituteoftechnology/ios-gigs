//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jordan Christensen on 9/5/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLoginModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        cell.textLabel?.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        cell.detailTextLabel?.text = gig.description
        cell.detailTextLabel?.textColor = UIColor(red: 0.95, green: 0.93, blue: 0.93, alpha: 1.00)
        
        
        cell.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        
        return cell
    }

    func setColors() {
        view.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        tableView.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.00)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.00)]
    }
    
    @IBAction func reloadDataTapped(_ sender: UIBarButtonItem) {
        gigController.getAllGigs(completion: { (networkError) in
            if let error = networkError {
                NSLog("There was an error fetching gigs: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLoginModalSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
            
        } else if segue.identifier == "ShowGigSegue" {
            guard let detailVC = segue.destination as? GigDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gig = gigController.gigs[indexPath.row]
            
        } else if segue.identifier == "ShowNewGigSegue" {
            guard let newGigVC = segue.destination as? GigDetailViewController else { return }
            newGigVC.gigController = gigController
            
        }
    }
}
