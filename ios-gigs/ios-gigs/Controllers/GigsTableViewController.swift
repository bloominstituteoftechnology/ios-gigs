//
//  GigsTableViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class GigsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let gigController = GigController()
    var delegate: User?
//    var gigs: [Gig] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
     checkBearer()
    runFetch()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "GigDetail" {
            if let detailVC = segue.destination as? GigDetailViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else {return}
                let gig = gigController.gigs[indexPath.row]
                detailVC.detailGig = gig
            }
        }
    }
    
    func checkBearer() {
        if gigController.bearer == nil {
                 performSegue(withIdentifier: "login", sender: self)
             }
    }

     //TODO: - Fetch Gigs Here
    func runFetch() {
        gigController.fetchGigs { result in
            if let gigs = try? result.get() {
                DispatchQueue.main.async {
                    self.gigController.gigs = gigs
                    self.tableView.reloadData()
                }
            }
        }
    }
    

}
    
    extension GigsTableViewController: UITableViewDataSource {
        
        // MARK: - Table view data source
        

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath) as? GigsTableViewCell else { return UITableViewCell()}
        
        let gig = gigController.gigs[indexPath.row]
        
        cell.gig = gig
        
        return cell
    }
  
}
