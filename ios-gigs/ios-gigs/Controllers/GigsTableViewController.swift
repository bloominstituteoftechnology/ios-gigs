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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
    }

     //TODO: - Fetch Gigs Here

}
    
    extension GigsTableViewController: UITableViewDataSource {
        
        // MARK: - Table view data source
        

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath) as? GigsTableViewCell else { return UITableViewCell()}
        
        return cell
    }
  
    
}
