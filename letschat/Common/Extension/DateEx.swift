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
    
    static func stringToDate(date:String) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }
        
        let splitedDate = date.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate
            }
        }
        
        return Date()
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: dt!)
    }
}
