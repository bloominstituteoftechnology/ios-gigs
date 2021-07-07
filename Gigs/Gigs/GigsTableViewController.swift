//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jorge Alvarez on 1/15/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
// cell is identifier

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    private var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
        // TODO: fetch gigs here
        gigController.fetchGigs { (result) in
            do {
                let gigs = try result.get()
                DispatchQueue.main.sync {
                    self.gigs = gigs
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        print("No bearer token exists")
                    case .badAuth:
                        print("Bearer token invalil")
                    case .otherError:
                        print("Other error occured, see log")
                    case .badData:
                        print("No data received, or data corrupted")
                    case .noDecode:
                        print("JSON could not be decoded")
                    case .noEncode:
                        print("JSON could not be ENCODED")
                    }
                }
            }
        }
        print("CURRENT GIGS: \(gigs)")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = gigs[indexPath.row].title
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: gigs[indexPath.row].dueDate)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        
        else if segue.identifier == "DetailGigSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.gig = gigs[indexPath.row]
                }
                detailVC.gigController = gigController
            }
        }
    
        else if segue.identifier == "AddGigSegue" {
            print("ADD SEGUE")
            let testGig = Gig(title: "TEST69", description: "des test", dueDate: Date())
            gigController.createGig(gig: testGig) { (result) in
                do {
                    let newGig = try result.get()
                    DispatchQueue.main.sync {
                        self.gigController.gigs.append(newGig)
                    }
                } catch {
                    print("Error creating gig in TVC: \(error)")
                }
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
