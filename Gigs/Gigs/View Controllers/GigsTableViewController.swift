//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_259 on 3/11/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let gigController = GigController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            // TODO: - fetch gigs here
            fetchGigs()
        }
    }
    
    func fetchGigs() {
        if gigController.bearer != nil {
            gigController.fetchGigs(completion: { (result) in
                if let gigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigs
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }

}
