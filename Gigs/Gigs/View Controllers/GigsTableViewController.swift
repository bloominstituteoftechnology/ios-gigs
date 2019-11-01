//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Niranjan Kumar on 10/30/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties

    var gigController = GigController()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.timeZone = .current
        return formatter
    }
    

    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // transition to login view if condition met
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            // TODO: fetch gigs here
            gigController.fetchGigs { (result) in
                do {
                    let gig = try result.get()
                    DispatchQueue.main.async {
                        self.gigController.gigs = gig
                        self.tableView.reloadData()
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth:
                            print("No bearer token exists")
                        case .badAuth:
                            print("Bearer token invalid")
                        case .otherError:
                            print("Other error occurred, see log")
                        case .badData:
                            print("No data received, or data corrupted")
                        case .noDecode:
                            print("JSON could not be decoded")
                        }
                    }
                }
            }
        }
    }
    
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        
        let gigDate = gigController.gigs[indexPath.row].dueDate
        
        cell.detailTextLabel?.text = dateFormatter.string(from: gigDate)
        

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddSegue" {
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
                detailVC.gig = gigController.gigs[indexPath.row]
            }
        }

    }
}
