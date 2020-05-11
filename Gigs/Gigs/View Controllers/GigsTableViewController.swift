//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by David Williams on 3/17/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigcontroller = GigController()
    private var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        if gigcontroller.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigcontroller.fetchAllGigs { (result) in
                do {
                    let titles = try result.get()
                    DispatchQueue.main.sync {
                        self.gigs = titles
                    }
                } catch {
                    if let error = error as? GigController.NetworkError {
                        switch error {
                        case .noAuth:
                            print("Error: No bearer token exists.")
                        case .unauthorized:
                            print("Error: Bearer token invalid")
                        case .noData:
                            print("Error: The response had no data.")
                        case .decodeFailed:
                            print("Error: The data could not be decoded.")
                        case .otherError(let otherError):
                            print("Error: \(otherError)")
                        case .failedSignUp:
                            print("Error: Failed signing up.")
                        case .failedSignIn:
                            print("Error: Failed signing in.")
                        case .noToken:
                            print("Invalid token")
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
      
        return gigcontroller.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        let gig = gigcontroller.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = gig.dueDate
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigcontroller
        } else if segue.identifier == "ShowGig",
            let showVC = segue.destination as? GigDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            showVC.gigController = gigcontroller
            showVC.gig = gigcontroller.gigs[selectedIndexPath.row]
        } else if  segue.identifier == "AddGig" {
            guard let addVC = segue.destination as? GigDetailViewController else { return }
            addVC.gigController = gigcontroller
        }
    }
}
