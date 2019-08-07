//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue"{
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }
}
