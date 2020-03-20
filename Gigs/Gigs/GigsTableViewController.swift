//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Morgan Smith on 1/21/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    
    let gigController = GigController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else  {
            
        gigController.fetchAllGigs { (result) in
            do {
                self.gigController.gigs = [try result.get()]
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .badAuth:
                        print("Error: Bad authorization")
                    case .badData:
                        print("Error: Bad data")
                    case .decodingError:
                        print("Error: Decoding error")
                    case .noAuth:
                        print("Error: No authorization")
                    case .otherError:
                        print("Error: Other error")
                    }
                }
            }
        }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        guard indexPath.row < gigController.gigs.count else {return cell}
        
        let gig = gigController.gigs[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.textLabel?.text = gig.title
        
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        if segue.identifier == "ShowGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else {
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard indexPath.row < gigController.gigs.count else {return}
            detailVC.gig = gigController.gigs[indexPath.row]
            detailVC.gigController = gigController
        }
        
        if segue.identifier == "AddGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else {
                return
            }
            
            detailVC.gigController = gigController
        }
        
    }
}
