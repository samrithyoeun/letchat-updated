//
//  Message.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message {
    var username = ""
    var time = ""
    var content = ""
    var type = ""
    
    static func jsonMapping(_ data: Data) -> Message {
        let jsonData = try! JSON(data: data)
        let array = jsonData.arrayValue
        let message = array[0]
        let content = message["content"].stringValue
        let username = message["username"].stringValue
        var time = message["createdAt"].stringValue
        time = Message.convertTime(time)
        let type = message["types"].stringValue
        let newMessage = Message(username: username, time: time, content: content, type: type)
        debug("new message")
        debug(newMessage)
        return newMessage
    }
    
    static func jsonMapping(_ data: JSON) -> [Message] {
        let json = data["data"].arrayValue
        var messages = [Message]()
        for message in json {
            let content = message["content"].stringValue
            let username = message["username"].stringValue
            var time = message["createdAt"].stringValue
            time = Message.convertTime(time)
            let type = message["types"].stringValue
            let newMessage = Message(username: username, time: time, content: content, type: type)
            messages.append(newMessage)
        }
        messages.reverse()
        debug(messages)
        return messages
    }
    
    public static func convertTime(_ time: String) -> String{
        let utcTime = Date.stringToDate(date: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let convertedTime = formatter.string(from: utcTime)
        debug("conver time \(convertedTime)")
        return convertedTime
        
    }
}
