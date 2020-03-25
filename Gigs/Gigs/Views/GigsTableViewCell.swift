//
//  GigsTableViewCell.swift
//  Gigs
//
//  Created by Joel Groomer on 9/10/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

class GigsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGig: UILabel!
    @IBOutlet weak var lblGigDueDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
