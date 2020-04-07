//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Chris Dobek on 4/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)


        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
        guard let loginVC = segue.destination as? LoginViewController else { return }
        
            loginVC.gigController = gigController
        }
    }
}
