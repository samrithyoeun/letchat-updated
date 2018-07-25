//
//  Channel.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/25/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Channel {
    
    var name  = ""
    var count = 0
    var id = ""
    
    public func getLabel() -> String{
        return "\(name)(\(count))"
    }
    
    public static func getChannels(_ value: JSON) -> [Channel]? {
        
        if let channelsArray = value["data"].array {
            var channels = [Channel]()
            for channel in channelsArray {
                let name = channel["name"].stringValue
                let count = channel["count"].intValue
                let id = channel["_id"].stringValue
                channels.append(Channel(name: name, count: count, id: id))
                
            }
        return channels
        }
    return nil
    }
    
    public static func setChannelId(_ id: String){
        UserDefaults.standard.set(id, forKey: Config.channel)
    }
    
    public static func getChannelId()-> String{
        return UserDefaults.standard.string(forKey: Config.channel) ?? ""
    }
}
