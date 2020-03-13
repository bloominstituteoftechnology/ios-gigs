//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bhawnish Kumar on 3/11/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    var gig: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         if gigController.bearer == nil {
                    performSegue(withIdentifier: "GigsModalSegue", sender: self)
                }
     }
    
    
    @IBAction func addAction(_ sender: Any) {
        gigController.fetchAllGigsNames { result in
                 do {
                     let names = try result.get()
                     DispatchQueue.main.async {
                        self.gig = names
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
                         }
                     }
                 }
             }
    }
    
 
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gig.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        cell.textLabel?.text = gig[indexPath.row]
        
        // Configure the cell...

        return cell
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GigsModalSegue" {
                   // inject dependencies
                   if let loginVC = segue.destination as? LoginViewController {
                       loginVC.gigController = gigController
                   }
                   } else if segue.identifier == "ShowGig" {
                       if let detailVC = segue.destination as? GigsDetailViewController {
                           detailVC.gigController = gigController
                           if let indexPath = tableView.indexPathForSelectedRow {
                               detailVC.gigName = gig[indexPath.row]
                           }
                       }
                   } else if segue.identifier == "addButtonSegue" {
                       if let detailVC = segue.destination as? GigsDetailViewController {
                           detailVC.gigController = gigController
                           if let indexPath = tableView.indexPathForSelectedRow {
                               detailVC.gigName = gig[indexPath.row]
                           }
                       }
                   }
    }
    

}
