//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Rob Vance on 5/8/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

// Mark Properties
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                do {
                    self.gigController.gigs = try result.get()
                } catch {
                    if let error = error as? GigController.NetworkError {
                        switch error {
                        case .noToken:
                            print("No Authorization")
                        case .noData:
                            print("No Data")
                        case .encodingError:
                            print("Encoding Error")
                        case .tryAgain:
                            print("Other Error")
                        default:
                            break
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)


        return cell
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigsSegue" {
            if let showGigVC = segue.destination as? GigDetailViewController {
                showGigVC.gigController = gigController
            }
        }
    }
    

}
