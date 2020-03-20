//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    // MARK: - Properties
    var gigController = GigController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "PresentLoginSegue", sender: self)
        } else {
            gigController.getAllGigs { (result) in
                do {
                    let _ = try result.get()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth:
                            print("Error: No bearer token exists.")
                        case .unauthorized:
                            print("Error: Bearer token invalid.")
                        case .noData:
                            print("Error: The response had no data.")
                        case .decodeFailed:
                            print("Error: The data could not be decoded.")
                            case .encodeFailed:
                            print("Error: The data could not be decoded")
                        case .otherError(let otherError):
                            print("Error: \(otherError)")
                        }
                    } else {
                        print("Error: \(error)")
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
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)

        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentLoginSegue", let loginVC = segue.destination as? LoginViewController {
            //dependency injection
            loginVC.gigController = gigController
        } else if segue.identifier == "AddNewGigSegue", let newDetailVC = segue.destination as? GigDetailViewController{
            //dependency injection
            newDetailVC.gigController = gigController
        } else if segue.identifier == "showGigSegue", let showDetailVC = segue.destination as? GigDetailViewController, let selectedIndexPath = tableView.indexPathForSelectedRow {
            //dependency injection
            showDetailVC.gigController = gigController
            showDetailVC.gig = gigController.gigs[selectedIndexPath.row]
        }
    }


}
