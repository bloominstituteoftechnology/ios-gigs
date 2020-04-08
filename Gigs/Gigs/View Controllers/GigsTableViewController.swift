//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/7/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

// delegate and data source
class GigsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var gigCongroller = GigController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if GigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewController", sender: self)
        }
        
        // TODO: fetch gigs here
    }
    
    // MARK: - TableView Data Source
}

extension GigsTableViewController {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        
        return cell
    }
}
