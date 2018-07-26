//
//  ConversationViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatViewController: UIViewController {
    
    @IBOutlet weak var stickerViewHeight: NSLayoutConstraint!
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
    var selectedKeyboard = true
    var inputImageName = "lol"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        messageTextField.delegate = self
        stickerViewHeight.constant = 0
        updateTableContentInset(forTableView: chatTableView)
        SocketIOManager.shared.setupSocket()
        SocketIOManager.shared.handleNewMessage { (data) in
            
            self.message = Message.jsonMapping(data)
            if self.message.username == User.getUsername() {
                debug("message successfully sent")
            } else {
                self.conversations.append(self.message)
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
        SocketIOManager.shared.handleOnlineUser { (any) in
            let count = (any[0] as AnyObject).integerValue
            self.onlineLabel.text = "Online: \(count!)"
            self.channelLabel.text = Channel.getChannelName()
            debug(Channel.getChannelName())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
        chatTableView.reloadData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
    }
   
    @IBAction func likeButtonTapped(_ sender: Any) {
        sendSticker("like")
    }
    
    @IBAction func supriseButtonTapped(_ sender: Any) {
        sendSticker("surprise")
    }
    
    @IBAction func cryButtonTapped(_ sender: Any) {
        sendSticker("cry")
    }
    
    @IBAction func lolButtonTapped(_ sender: Any) {
        sendSticker("lol")
    }
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
        if inputImageName == "keyboard-white" {
            inputImageName = "lol"
            stickerViewHeight.constant = 0
            messageTextField.becomeFirstResponder()
           
        } else {
            inputImageName = "keyboard-white"
            stickerViewHeight.constant = 60
        }
        
        inputButton.setImage(UIImage(named: inputImageName), for: .normal)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        message.username = User.getUsername()
        message.time = Date.getCurrentTime()
        message.content = messageTextField.text ?? "some error text"
        message.type = MessageType.message.rawValue
        SocketIOManager.shared.sendMessage(type: MessageType.message, content: message.content)
        conversations.append(message)
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    private func sendSticker(_ sticker: String){
        debug("\(sticker) button tapped")
        message.username = User.getUsername()
        message.time = Date.getCurrentTime()
        message.type = MessageType.sticker.rawValue
        message.content = sticker
        SocketIOManager.shared.sendMessage(type: MessageType.sticker, content: message.content)
        conversations.append(message)
        chatTableView.reloadData()
        scrollToBottom()
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
            if message.username == User.getUsername() {
                debug("sicker cell")
                cell = chatTableView.dequeueReusableCell(withIdentifier: "outGoingImage") as! OutGoingImageTableViewCell
            }else {
                debug("sicker cell")
                cell = chatTableView.dequeueReusableCell(withIdentifier: "incomingImage") as! InComingImageTableViewCell
            }
        } else {
            if message.username == User.getUsername() {
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
        selectedKeyboard = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedKeyboard = true
        pushView(-250)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        pushView(250)
        selectedKeyboard = false
    }
    
    func pushView(_ constant : CGFloat){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + constant, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
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
