//
//  GigsTableViewCell.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class GigsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gigTitleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var gig: Gig? {
        didSet {
            updateValues()
        }
    }
    
    
    func updateValues() {
        guard let gig = gig else {return}
        gigTitleLabel.text = gig.title
        dueDateLabel.text = dateFormatter.string(from: gig.dueDate)
    }

}
