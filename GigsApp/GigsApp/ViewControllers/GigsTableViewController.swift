//
//  GigsTableViewController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/8/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //MARK: - Properties
    let gigController = GigController()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil{
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.getAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
//        gigController.getAllGigs { (result) in
//            do{
//                let gigs = try result.get()
//                DispatchQueue.main.async {
//                    self.gigController.gigList = gigs
//                }
//            } catch {
//                if let error = error as? GigController.NetworkError {
//                    switch error {
//                    case .noToken:
//                        print("have user try to log in again")
//                    case .noData, .tryAgain:
//                        print("have user try again")
//                    default:
//                        break
//                    }
//                }
//            }
            
//        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gigs = gigController.gigList[indexPath.row]
        cell.textLabel?.text = gigs.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigs.dueDate)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue"{
            if let loginVC = segue.destination as? LoginViewController{
                loginVC.gigController = gigController
            }
        }
        else if segue.identifier == "AddGigSegue"{
            if let addGigVC = segue.destination as? GigDetailViewController{
                addGigVC.gigController = gigController
            }
        } else if segue.identifier == "GigDetailSegue"{
            if let gigDetailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow{
                gigDetailVC.gigController = gigController
                gigDetailVC.gig = gigController.gigList[indexPath.row]
            }
        }
    }
}
