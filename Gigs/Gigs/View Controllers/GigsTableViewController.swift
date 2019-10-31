//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_204 on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigController = GigController()
    private let dateFormatter = DateFormatter()
    
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
            fetchAllGigs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func fetchAllGigs() {
        gigController.getAllGigs { error in
            if let error = error {
                switch error {
                case .noAuth:
                    print(NetworkError.noAuth.rawValue)
                case .badAuth:
                    print(NetworkError.badAuth.rawValue)
                case .otherError:
                    print(NetworkError.otherError.rawValue)
                case .badData:
                    print(NetworkError.badData.rawValue)
                case .noDecode:
                    print(NetworkError.noDecode.rawValue)
                case .noEncode:
                    print(NetworkError.noEncode.rawValue)
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "LoginModalSegue":
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        case "ShowDetailGigSegue":
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
                detailVC.gig = gigController.gigs[indexPath.row]
            }
        case "AddGigViewSegue":
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        default:
            return
        }
    }
}
