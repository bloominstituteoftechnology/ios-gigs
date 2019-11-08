//
//  GigsTableViewCell.swift
//  iosGigs
//
//  Created by denis cedeno on 11/7/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class GigsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gigsNameTitleLabel: UILabel!
    
    @IBOutlet weak var dueDateSubLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    var gig: Gig?{
        didSet{
            dateFormatter.dateFormat = "MM/dd/yy"
            updateViews()
        }
    }
    
    func updateViews(){
        guard let gig = gig else { return }
        
        gigsNameTitleLabel.text = gig.title
        dueDateSubLabel.text = dateFormatter.string(from: gig.dueDate)
    }
}
