//
//  DateEx.swift
//  letschat
//
//  Created by PM Academy 3 on 7/26/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
extension Date {
    static func getCurrentTime() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
