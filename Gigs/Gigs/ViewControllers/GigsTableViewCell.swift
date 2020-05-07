//
//  GigsTableViewCell.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/6/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class GigsTableViewCell: UITableViewCell {

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var gigTitleLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        guard let gig = gig else { return }
        gigTitleLabel.text = gig.title
        dueDateLabel.text = dateFormatter.string(from: gig.dueDate)
    }
}
