//
//  MainTableVC.swift
//  GigS
//
//  Created by Nick Nguyen on 2/12/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
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
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            //TODO: Fetch gigs here
        }
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }
    

}
