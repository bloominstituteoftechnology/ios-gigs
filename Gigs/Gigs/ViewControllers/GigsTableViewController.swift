//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    
    //MARK: - Properties
    
    private var gigController = GigController()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gigController.bearer != nil {
            gigController.fetchAllGigs { error in
                DispatchQueue.main.async {
                    if let error = error {
                        NSLog("Error trying to fetch gigs: \(error)")
                    } else {
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)
        }
    }
    
    
    // MARK: - Private
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    //MARK: - Table View Data Source

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

    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        }
        
        if let gigDetailVC = segue.destination as? GigDetailViewController {
            gigDetailVC.gigController = gigController
            
            if segue.identifier == "ShowGig" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    gigDetailVC.gig = gigController.gigs[indexPath.row]
                }
            }
        }
    }
    

}
