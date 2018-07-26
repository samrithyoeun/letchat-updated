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
    
//    static let sharedInstance = SocketIOManager()
//    var socket = SocketIOClient(socketURL: URL(string: ServerEnvironment.chatRoom)
//
//    override init() {
//        super.init()
//
//        socket.joinNamespace("/swift") // Create a socket for the /swift namespac
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected \(data)")
//
//            let id:String = getDataFromPreference(key: ID)
//            let identifier:String = getDataFromPreference(key: IDENTIFIER)
//            self.socket.emit(
//                "client join", ["id":clientId, "identifier":identifier]
//            )
//
//        }
//
//        socket.on("client balance change") { dataArray, ack in
//            print("socket connected \(dataArray)")
//        }
//
//    }
//
//    func establishConnection() {
//        socket.connect()
//    }
//
//    func closeConnection() {
//        socket.disconnect()
//    }
}
