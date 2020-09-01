//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chris Dobek on 4/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigController = GigController()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.getAllGigs { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("Failed fetching gigs.")
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "LoginModalSegue" {
           guard let loginVC = segue.destination as? LoginViewController else { return }
           
               loginVC.gigController = gigController
           } else if  segue.identifier == "ShowGigSegue" {
            guard let detailVC = segue.destination as? GigDetailViewController,
                           let indexPath = tableView.indexPathForSelectedRow
                           else { return }

                       detailVC.gigController = gigController
                       detailVC.gig = gigController.gigs[indexPath.row]
           } else if segue.identifier == "AddNewGigSegue" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }

                       detailVC.gigController = gigController
        }
       }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let formattedDate = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)

        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = formattedDate

        return cell
    }

    
   
}
