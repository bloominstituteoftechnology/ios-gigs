//
//  IBDesignable-UIView+roundedCorners.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
extension UIView {
    @IBInspectable private var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.masksToBounds = newValue > 0
               layer.cornerRadius = newValue
           }
   }
}
