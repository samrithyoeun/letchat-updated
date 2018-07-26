//
//  ConversationViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController {

    @IBOutlet weak var letchatLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var smileButton: UIButton!
    @IBOutlet weak var sadFaceButton: UIButton!
    @IBOutlet weak var supriseFaceButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var inputHolderView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableButtomConstriant: NSLayoutConstraint!
    @IBOutlet weak var inputsView: UIView!
    
    lazy var labelGroup = [letchatLabel, channelLabel, onlineLabel]
    lazy var buttonGroup = [settingButton, inputButton, sendButton, sadFaceButton, supriseFaceButton, likeButton, smileButton]
    lazy var viewGroup = [chatTableView, view, stickerView, inputsView, headerView]
    
    let manager = SocketManager(socketURL: URL(string: ServerEnvironment.socket)!, config: [.log(true), .compress])
    lazy var socket = manager.socket(forNamespace: "/chatroom")
    
    var conversations = [Message]()
    var testSendingMessage  = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        messageTextField.delegate = self
        updateTableContentInset(forTableView: chatTableView)
        
       setupSocket()
    }
    
    public func setupSocket(){

      
        socket.connect()

        socket.on(clientEvent: .connect) {data, ack in
            debug("socket connected")
            self.socket.emit("join", User.getUserId())
            
            let data : [String: Any] = ["userId": User.getUserId(),
                                        "content": "some message"
            ]
            
            self.socket.emit("newMessage", data)
            self.retereiveOldMessage()
        }

        socket.on(clientEvent: .error) {data, ack in
            debug("socket error")
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            debug("socket disconnect")
        }
        
        socket.on(clientEvent: .statusChange) {data, ack in
            debug("socket status change")
        }
        
        socket.on(clientEvent: .ping) {data, ack in
            debug("socket status change")
        }
        
        socket.on("addMessage") { (any, ack) in
            debug(any)
            debug(ack)
        }
        
        socket.on("count") { (any, ack) in

            debug(any)
            debug(ack)
        }
        
        
        
     
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
        chatTableView.reloadData()
    }
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
//        inputViewBottomConstraint.constant += 50
//        print(chatTableButtomConstriant.constant)
//        updateTableContentInset(forTableView: chatTableView)
//        scrollToBottom()

    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendMessage(Message(username: User.getUserId(), time: "", content: "Some message from samrith", type: ""))
        chatTableView.reloadData()
//        scrollToBottom()
    }
    
    private func sendMessage(_ message: Message){

//        let data = ["userId": User.getUserId(),
//                    "content": message.content
//                    ]
//        if let theJSONData = try?  JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
//            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
//                print("JSON string = \n\(theJSONText)")
//
//            socket.emit("newMessage", theJSONText)
//        }

    
    }
    
    private func setDummyData(){
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 1 ?", type: "message"))
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 2 ?", type: "message"))
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 3 ?", type: "message"))
    
    }
    
    private func retereiveOldMessage(){
        let limit = 20
        let channelId = Channel.getChannelId()
        let endpoint = "/channels/\(channelId)/messages?limit=\(limit)"
        APIRequest.get(endPoint: endpoint){ (json, code, error) in
            print("----- retreive old message")
            print(error ?? "")
            print(code ?? "")
            print(json)
            //TODO: handle old message
        }
    }
    
    private func updateTableContentInset(forTableView tv: UITableView) {
        let numSections = tv.numberOfSections
        var contentInsetTop = chatTableView.bounds.size.height
        
        
        for section in 0..<numSections {
            let numRows = tv.numberOfRows(inSection: section)
            let sectionHeaderHeight = tv.rectForHeader(inSection: section).size.height
            let sectionFooterHeight = tv.rectForFooter(inSection: section).size.height
            contentInsetTop -= sectionHeaderHeight + sectionFooterHeight
            for i in 0..<numRows {
                let rowHeight = tv.rectForRow(at: IndexPath(item: i, section: section)).size.height
                contentInsetTop -= rowHeight
                if contentInsetTop <= 0 {
                    contentInsetTop = 0
                    break
                }
            }
            if contentInsetTop == 0 {
                break
            }
        }
        tv.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
    }

}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.conversations.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = chatTableView.dequeueReusableCell(withIdentifier: "incomingMessage") as! InComingMessageTableViewCell
        let message = conversations[indexPath.row]
        cell.bindDataFrom(message)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("start editing")
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("stop editing")
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
}

extension ChatViewController: ThemeManagerProtocol{
    func changeThemeTo(_ theme: Theme) {
        ThemeManager.changeTo( theme) { (firstColor, secondColor) in
            
            for view in viewGroup {
                view?.backgroundColor = firstColor
            }
            
            lineView.backgroundColor = secondColor
            inputHolderView.backgroundColor = secondColor
            
            for label in labelGroup {
                label?.textColor = secondColor
            }
            
            for button in buttonGroup {
                button?.setTitleColor(secondColor, for: .normal)
                button?.imageView?.tintColor = secondColor
            }
            
            messageTextField.backgroundColor = secondColor
            messageTextField.textColor = firstColor
            messageTextField.setPlaceHolderColor(firstColor)
        }
    }
}



