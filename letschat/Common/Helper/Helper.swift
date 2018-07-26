//
//  Helper.swift
//  Project
//
//  Created by Ricky_DO on 3/19/18.
//  Copyright © 2018 Pathmazing. All rights reserved.
//

import Foundation
import UIKit

func alert(message: String, title: String = "") {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
}

func debug(_ item: Any){
    print(" ==========> \(item)")
}
