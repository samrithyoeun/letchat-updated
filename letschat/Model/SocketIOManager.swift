//
//  SocketService.swift
//  letschat
//
//  Created by Samrith Yoeun on 7/25/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: ServerEnvironment.socket)!, config: [.log(true), .compress])
    lazy var socket = manager.socket(forNamespace: "/chatroom")
    
    
    public func setupSocket(){
        socket.connect()
        joinChatGroup()
        socket.on(clientEvent: .error) {error, ack in
            debug("error in socket")
            debug(error)
            debug(ack)
        }
        
        socket.on(clientEvent: .disconnect) {status, ack in
            debug("socket disconnect")
            debug(status)
            debug(ack)
        }
        
        socket.on(clientEvent: .statusChange) {status, ack in
            debug("socket status change")
            debug(status)
            debug(ack)
        }
        
        socket.on(clientEvent: .ping) {ping, ack in
            debug("socket status ping")
            debug(ping)
            debug(ack)
        }
        
       
    }
    
    public func handleNewMessage(callback: @escaping (Data)->() ){
        socket.on("addMessage") { (data, ack) in
            debug("geting new message")
            debug(data)
            debug(ack)
            if let json = convertToJson(data: data){
                callback(json)
            }
        }
    }
    
    public func handleOnlineUser(callback: @escaping ([Any])->() ){
        socket.on("count") { (any, ack) in
            debug("online user")
            debug(type(of: any))
            debug(ack)
            callback(any)
        }
    }
    
    public func joinChatGroup(){
        socket.on(clientEvent: .connect) {data, ack in
            debug("socket connected")
            self.socket.emit("join", User.getUserId())
        }
    }
    
    public func sendMessage(type: MessageType, content: String){
        let data : [String: Any] = ["userId": User.getUserId(),
                                    "content": content,
                                    "types": type.rawValue
                                    ]
        
        debug("message Value")
        debug(data)
        self.socket.emit("newMessage", data)
    }
    
    public func retereiveOldMessage(limit: Int = 10, skipTime: Int = 0, callback: @escaping (Result<[Message]>) ->()) {
        
        let channelId = Channel.getChannelId()
        let endpoint = "/channels/\(channelId)/messages?limit=\(limit)"
        APIRequest.get(endPoint: endpoint){ (json, code, error) in
            debug("retreive old message")
            print(error ?? "")
            print(code ?? "")
            if error == nil {
                let messages = Message.jsonMapping(json)
                callback(Result.success(messages))
            } else {
                callback(Result.failure(error.debugDescription))
            }
        }
    }
    
}
