//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 3/11/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //
    //    @IBOutlet weak var gigTitleLabel: UILabel!
    //    @IBOutlet weak var dueDateLabel: UILabel!
    
//    private var gigTitles: [String] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    private(set) var gigController = GigController()
    //var gig: Gig!
    let df = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            // TODO: fetch gigs here
        } else {
            gigController.fetchAllGigs { result in
                do {
                    let gigsListed = try result.get()
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigsListed
                        self.tableView.reloadData()
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth:
                            NSLog("No bearer token exists")
                        case .badAuth:
                            NSLog("Bearer token invalid")
                        case .otherError:
                            NSLog("Other error occurred, see log")
                        case .badData:
                            NSLog("No data received, or data corrupted")
                        case .noDecode:
                            NSLog("JSON could not be decoded")
                        case .badUrl:
                            NSLog("URL invalid")
                        case .noEncode:
                            NSLog("Error with encoding data")
                        }
                    }
                }
                //
                ////                do-try-catch result.get
                ////                dispatch main - tableView.reload
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
        
        // Configure the cell...
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        df.dateStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
                if let gigDetailVC = segue.destination as? GigDetailViewController {
                    gigDetailVC.gigController = gigController
                    if let indexPath = tableView.indexPathForSelectedRow {
                        gigDetailVC.gig = gigController.gigs[indexPath.row]
                        
                    }
                }
            }
        }
    }


