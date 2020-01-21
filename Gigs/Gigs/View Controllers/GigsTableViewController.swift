//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/21/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)

         if gigController.bearer == nil {
             performSegue(withIdentifier: "LoginModalSegue", sender: self)
         }
        
     }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == "LoginModalSegue" {
             if let loginVC = segue.destination as? LoginViewController {
                 loginVC.gigController = gigController
             }
         }
     }

}
