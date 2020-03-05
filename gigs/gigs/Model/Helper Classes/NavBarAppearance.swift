//
//  NavBarAppearance.swift
//  gigs
//
//  Created by Kenny on 1/16/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit


class NavBarAppearance {
    class func appearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = UIColor(named: "Primary")
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return customNavBarAppearance
    }
}
