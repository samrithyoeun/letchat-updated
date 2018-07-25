//
//  User.swift
//  letschat
//
//  Created by PM Academy 3 on 7/25/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    var name = ""
    var id = ""
    var channelId = ""
    
    public mutating func setData(_ value: Any){
        let json = JSON(value)
        name = json["username"].stringValue
        id = json["_id"].stringValue
        channelId = json["channelId"].stringValue
        print(self)
        UserDefaults.standard.set(id, forKey: Config.user)
    }
    
    public static func getUserId() -> String{
        return UserDefaults.standard.string(forKey: Config.user) ?? ""
    }
    
    public static func setUserId(_ id: String){
        UserDefaults.standard.set(id, forKey: Config.user)
    }
}
