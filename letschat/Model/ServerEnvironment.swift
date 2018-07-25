//
//  ServerEnvironment.swift
//  letschat
//
//  Created by PM Academy 3 on 7/25/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
struct ServerEnvironment {
    #if DEV_ENVIRONMENT
    static let localIp = "http://192.168.168.168:8080"
    static let host = "https://fierce-wildwood-40527.herokuapp.com/api/v1"
    static let chatRoom = "https://fierce-wildwood-40527.herokuapp.com/chatroom"
    #else
    static let localIp = "http://pathmazing.com"
    static let host = "https://fierce-wildwood-40527.herokuapp.com/api/v1"
    static let chatRoom = "https://fierce-wildwood-40527.herokuapp.com/chatroom"
    #endif
}
