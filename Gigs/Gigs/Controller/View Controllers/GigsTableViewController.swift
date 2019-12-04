//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let authController = AuthenticationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if authController.bearer == nil {
            performSegue(withIdentifier: "ShowLoginSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowLoginSegue":
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.authController = authController
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
}
