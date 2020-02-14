//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by scott harris on 2/12/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            // TODO: fetch gigs here
            gigController.fetchGigs { (result) in
                do {
                    let _ = try result.get()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                            case .noAuth:
                                NSLog("No Bearer token, please log in.")
                            case .badAuth:
                                NSLog("Bearer token invalid.")
                            case .otherError:
                                NSLog("Generic netowrk error occured")
                            case .badData:
                                NSLog("Data received was invalid, corrupt, or doesnt exist")
                            case .noDecode:
                                NSLog("Gig JSON data could not be decoded")
                            default:
                                NSLog("Other error ocured")
                            
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigDetailSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
            
        }  else if segue.identifier == "ShowGigDetailSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let gig = gigController.gigs[selectedIndex.row]
                    detailVC.gig = gig
                    detailVC.gigController = gigController
                }
                
            }
            
        }
    }
    
    
    
}
