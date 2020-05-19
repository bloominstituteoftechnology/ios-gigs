//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Ahava on 5/8/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
     enum NetworkError: Error {
           case noAuth
           case badAuth
           case otherError
           case badData
           case noDecode
    }

    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        
        gigController.fetchAllGigs { (result) in
            do {
                self.gigController.gigs = try result.get()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        NSLog("No bearer token, please log in")
                    case .badAuth:
                        NSLog("Bearer token invalid")
                    case .otherError:
                        NSLog("Generic network error occurred")
                    case .badData:
                        NSLog("Data recieved was invalid, corrupt, or doesn't exist")
                    case .noDecode:
                        NSLog("JSON data could not be decoded")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        let dateString = dateFormatter.string(from: gig.dueDate)
        
//        print(gig.title)
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateString

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        } else if segue.identifier == "addGigSegue" {
            if let viewController = segue.destination as? GigDetailViewController {
                viewController.gigController = gigController
            }
        } else if segue.identifier == "gigDetailSegue" {
            if let viewController = segue.destination as? GigDetailViewController {
                viewController.gigController = gigController
                if let indexPath = tableView.indexPathForSelectedRow {
                    viewController.gig = gigController.gigs[indexPath.row]
                }
            }
        }
    }
    

}
