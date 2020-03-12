//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Wyatt Harrell on 3/11/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    let dateFormatter = DateFormatter()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gigController.getAllGigs { (result) in
            do {
                let gigs = try result.get()
                DispatchQueue.main.async {
                    self.gigController.gigs = gigs
                    self.tableView.reloadData()
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth: //You could make an alert controller for these
                        NSLog("No bearer token exists") //These are developer facing but you could have one for user one for developer
                    case .badAuth:
                        NSLog("Bearer token invalid")
                    case .otherError:
                        NSLog("Other error occured, see log")
                    case .badData:
                        NSLog("No data received, or data corrupted")
                    case .noDecode:
                        NSLog("JSON could not be decoded")
                    }
                }
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
        dateFormatter.timeStyle = .none
        cell.detailTextLabel?.text = "Due \(dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate))"
        
        return cell
    }
  

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let SignInVC = segue.destination as? LoginViewController else {
                return
            }
            
            SignInVC.gigController = gigController
        } else if segue.identifier == "ShowGig" {
            guard let ShowGigVC = segue.destination as? GigDetailViewController else {
                return
            }
            
            guard let selected = tableView.indexPathForSelectedRow else { return }
            
            ShowGigVC.gig = gigController.gigs[selected.row]
        } else if segue.identifier == "ShowNewGig" {
            guard let ShowNewGigVC = segue.destination as? GigDetailViewController else {
                return
            }
            
            ShowNewGigVC.gigController = gigController
        }
    }

}
