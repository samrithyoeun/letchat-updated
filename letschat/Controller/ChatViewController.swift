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
    
    var conversations = [Message]()
    var message = Message()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        messageTextField.delegate = self
        
        updateTableContentInset(forTableView: chatTableView)
        
        SocketIOManager.shared.setupSocket()
        SocketIOManager.shared.handleNewMessage { (data) in
            
            self.message = Message.jsonMapping(data)
            if self.message.username == User.getUsername() {
                // just a response of the sent message from sender
            } else {
                self.conversations.append(self.message)
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
        SocketIOManager.shared.handleOnlineUser { (any) in
            print(any)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
        chatTableView.reloadData()
    }
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {

    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        message.username = "sender"
        message.time = Date.getCurrentTime()
        message.content = messageTextField.text ?? ""
        SocketIOManager.shared.sendMessage(type: MessageType.message, content: message.content)
        conversations.append(message)
        chatTableView.reloadData()
        scrollToBottom()
    }

    
    private func setDummyData(){
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 1 ?", type: "message"))
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 2 ?", type: "message"))
        conversations.append(Message(username: "Sam", time: "12:00pm", content: "Hello there what is the 3 ?", type: "message"))
    
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
        
        let message = conversations[indexPath.row]
        var cell: TemplateTableViewCell
        if message.type == "sticker" {
            if message.username == "sender" {
                cell = chatTableView.dequeueReusableCell(withIdentifier: "outGoingImage") as! OutGoingImageTableViewCell
            }else {
                cell = chatTableView.dequeueReusableCell(withIdentifier: "incomingImage") as! InComingImageTableViewCell
            }
        } else {
            if message.username == "sender" {
                cell = chatTableView.dequeueReusableCell(withIdentifier: "outGoingMessage") as! OutGoingMessageTableViewCell
            }else {
                cell = chatTableView.dequeueReusableCell(withIdentifier: "incomingMessage") as! InComingMessageTableViewCell
            }
        }
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
