//
//  LoadingScreenViewController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    
    var message: String? { didSet { updateMessageLabel() }}
    
    
    // MARK: - Private
    
    func updateMessageLabel() {
        if isViewLoaded {
            messageLabel.text = message
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        updateMessageLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
    }
}
