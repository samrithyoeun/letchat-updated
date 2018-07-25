//
//  UITextFieldEx.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceHolderColor(_ color : UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
}
