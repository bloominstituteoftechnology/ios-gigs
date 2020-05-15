//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Clean Mac on 5/14/20.
//  Copyright © 2020 LambdaStudent. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let reuseIdentifier = "gigsTableViewCell"
    let apiController: APIController = APIController()
    private var gigs: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = gigs[indexPath.row]
        return cell
    }
    
    @IBAction func getGigs(_ sender: UIBarButtonItem) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
