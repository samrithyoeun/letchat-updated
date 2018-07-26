//
//  SocketService.swift
//  letschat
//
//  Created by Samrith Yoeun on 7/25/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    var socket: SocketIOClient?

    override init() {
        super.init()
        let manager = SocketManager(socketURL: URL(string: ServerEnvironment.chatRoom)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        socket?.connect()
        socket?.on(clientEvent: .connect) {data, ack in
            debug("socket connected \(data)")
        }
        socket?.emit("join", User.getUserId())
        socket?.on("count", callback: { (any, ack) in
            debug(any)
            debug(ack)
        })
    }
    
    func establishConnection() {
        socket?.connect()
    }

    func closeConnection() {
        socket?.disconnect()
    }
}
