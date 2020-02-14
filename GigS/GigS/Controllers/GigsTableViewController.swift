//
//  MainTableVC.swift
//  GigS
//
//  Created by Nick Nguyen on 2/12/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }
    
    
    private let gigController = GigController()
    
    // MARK:- App Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            //TODO: Fetch gigs here
            gigController.fetchAllGigs { result in
                do {
                    let gigs = try result.get()
                    DispatchQueue.main.async {
                         self.gigController.gigs = gigs // "A-ha 1" 
                        self.tableView.reloadData()
                       
                    }
                } catch {
                    print("\(error)")
                }
                
            }
        }
        
    }
    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let stringDate = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = stringDate
        
        
        
        // This is for tomorrow
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let destVC = segue.destination as? LoginViewController {
                destVC.gigController = gigController
            }
        }  else if segue.identifier == "ShowGigSegue" {
            if let destVC = segue.destination as? GigDetailViewController {
                guard let index = tableView.indexPathForSelectedRow else { return }
                destVC.gig = gigController.gigs[index.row]
                destVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let destVC = segue.destination as? GigDetailViewController {
                destVC.gigController = gigController
            }
        }
    }
}
