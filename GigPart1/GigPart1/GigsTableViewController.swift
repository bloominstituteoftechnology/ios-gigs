//
//  GigsTableViewController.swift
//  GigPart1
//
//  Created by Lambda_School_Loaner_218 on 12/4/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGigs()
        
    }
    private func fetchGigs() {
        gigController.getallGigs { results in
            if let gigs = try? results.get() {
                self.gigs = gigs
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLogingSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    }
    

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowLogingSegue":
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        case "ShowGigsSegue":
            guard let gigDetialVC = segue.destination as? GigDetialViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            gigDetialVC.gigController = gigController
            gigDetialVC.gig = self.gigs[indexPath.row]
        case "ButtonShowSegue":
            guard let gigDetialVC = segue.destination as? GigDetialViewController else { return }
            gigDetialVC.gigController = gigController
            gigDetialVC.delegate = self
        default:
            break
        }
    }
    

}
extension GigsTableViewController: GigDelegate {
    func didCreate(gig: Gig) {
        self.gigs.append(gig)
    }
    
    
}
