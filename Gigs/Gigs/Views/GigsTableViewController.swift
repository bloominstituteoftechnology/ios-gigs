//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Breena Greek on 3/17/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let gigController = GigController()
    var gigs: [Gig] = []
    var gigName: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var date: DateFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        }
               gigController.fetchAllGigNames { (result) in
                    do {
                        let names = try result.get()
                        DispatchQueue.main.async {
                            self.gigName = names
                        }
                    } catch {
                        if let error = error as? NetworkError {
                            switch error {
                            case .noAuth:
                                print("Error: No bearer token exists.")
                            case .unauthorized:
                                print("Error: Bearer token invalid.")
                            case .noData:
                                print("Error: Response had no data")
                            case .decodeFailed:
                                print("Error: The data could not be decoded.")
                            case .otherError(let otherError):
                                print("Error: \(otherError)")
                            }
                        } else {
                            print("Error: \(error)")
                        
                    
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        
        let gig = gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        } else if segue.identifier == "ShowDetailSegue",
            let detailVC = segue.destination as? GigDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            detailVC.gigController = gigController
            detailVC.gigName = gigName[selectedIndexPath.row]
        }
        
    }
}


