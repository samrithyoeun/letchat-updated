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
        let time = message["createdAt"].stringValue
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
            let time = message["createdAt"].stringValue
            let type = message["types"].stringValue
            let newMessage = Message(username: username, time: time, content: content, type: type)
            messages.append(newMessage)
        }
        messages.reverse()
        debug(messages)
        return messages
    }
    
}

enum MessageType: String {
    case sticker = "sticker"
    case message = "message"
}
