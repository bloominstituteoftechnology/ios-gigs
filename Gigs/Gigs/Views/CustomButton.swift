//
//  CustomButton.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
}
