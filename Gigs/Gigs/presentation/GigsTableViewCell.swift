//
//  GigsTableViewCell.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/6/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import UIKit

class GigsTableViewCell: UITableViewCell {
    @IBOutlet var gigTitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var gig: Gig? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let gig = gig {
            gigTitleLabel.text = gig.title
            
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .short
            
            let dateString = "Due \(dateFormat.string(from: gig.dueDate))"
            dateLabel.text = dateString
        }
    }
}
