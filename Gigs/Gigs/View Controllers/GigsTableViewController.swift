//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/7/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController, GigControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        gigController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogInSegue", sender: self)
        }
        
        gigController.getGig() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {

        gigController.getGig {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.gigController.gigs.count)
            }
        }
    }
    //Updates TableView
    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Variables
    var gigController = GigController()
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell", for: indexPath)

        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        //TODO: Set Date
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        
        if identifier == "LogInSegue" {
            print("Segue Performed")
            if let destination = segue.destination as? LogInViewController {
                destination.gigController = gigController
            }
        } else if identifier == "showGigSegue" {
            if let destination = segue.destination as? GigDetailViewController {
                destination.gigController = gigController
                destination.delegate = self
            }
        }
    }
}
