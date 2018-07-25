//
//  UIColorEx.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct ThemeColor {
        static let black = UIColor(netHex: 0x000000)
        static let white = UIColor(netHex: 0xffffff)
        static let purple = UIColor(netHex: 0x443266)
        static let yellow = UIColor(netHex: 0xF5E050)
        static let blue = UIColor(netHex: 0x1E6A9F)
    }
    
}
