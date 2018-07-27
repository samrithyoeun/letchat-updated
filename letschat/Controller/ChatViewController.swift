//
//  ConversationViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReverseExtension

class ChatViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
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
    lazy var viewGroup = [chatTableView, view, stickerView, inputsView, headerView, containerView]
    
    var conversations = [Message]()
    var message = Message()
    var selectedKeyboard = true
    var fetchingMore = false
    var inputImageName = "lol"
    var skipTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        ControllerManager.shared.chat = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        messageTextField.delegate = self
        stickerViewHeight.constant = 0
        chatTableView.re.delegate = self
        
        getOldData()
        
        SocketIOManager.shared.setupSocket()
        SocketIOManager.shared.handleNewMessage { (data) in
            
            self.message = Message.jsonMapping(data)
            if self.message.username == User.getUsername() {
                debug("sent message : \(self.message)")
              
            } else {
                
                self.conversations.insert(self.message, at: 0)
                self.chatTableView.reloadData()
                self.scrollToBottom()
                self.handleBeepSound()
            }
        }
        
        SocketIOManager.shared.handleOnlineUser { (any) in
            let count = (any[0] as AnyObject).integerValue
            self.onlineLabel.text = "Online Users: \(count!)"
            self.channelLabel.text = "#\(Channel.getChannelName())"
            debug(Channel.getChannelName())
        }
        
        SocketIOManager.shared.handleDisconnect {
            alert(message: "Unstabble Connection !")
            self.dismiss(animated: true, completion: {
                debug("handle .disconnect by going back to lockscreen")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
        chatTableView.reloadData()
        chatTableView.re.scrollViewDidReachTop = {
            scrollView in
            debug("scrollview reach top")
            if !self.fetchingMore {
                self.beginBatchFetch()
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
            messageTextField.resignFirstResponder()
        }
        inputButton.setImage(UIImage(named: inputImageName), for: .normal)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        if messageTextField.text != "" {
            message.username = User.getUsername()
            message.time = Date.getCurrentTime()
            message.content = messageTextField.text ?? "some error text"
            message.type = MessageType.message.rawValue
            SocketIOManager.shared.sendMessage(type: MessageType.message, content: message.content)
            conversations.insert(message, at: 0)
            chatTableView.reloadData()
            scrollToBottom()
            messageTextField.text = ""
            messageTextField.resignFirstResponder()
        }
    }
    
    public func gotoLockScreen(){
        self.present(ControllerManager.shared.login!, animated: true) {}
    }
    
    private func sendSticker(_ sticker: String){
        debug("\(sticker) button tapped")
        message.username = User.getUsername()
        message.time = Date.getCurrentTime()
        message.type = MessageType.sticker.rawValue
        message.content = sticker
        SocketIOManager.shared.sendMessage(type: MessageType.sticker, content: message.content)
        conversations.insert(message, at: 0)
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    private func getOldData(){
        SocketIOManager.shared.retereiveOldMessage(limit: self.conversations.count+10, skip: self.conversations.count, callback: { (result) in
            switch result {
            case .success(let oldMessages):
                for message in oldMessages {
                    self.conversations.insert(message, at: 0)
                }
                self.chatTableView.reloadData()
            case .failure(let error):
                debug(error)
            }
        })
    }
    
    private func handleBeepSound(){
        let setting = UserDefaults.standard.bool(forKey: Config.sound)
        if setting == true {
            SoundPlayer.shared.playSound()
        }
        debug("sound \(setting)")
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        skipTime += 1
        debug("beginBatchFetch! \(skipTime)")
        chatTableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            SocketIOManager.shared.retereiveOldMessage(limit: self.conversations.count+10, skip: self.conversations.count, callback: { (result) in
                switch result {
                case .success(var oldMessages):
                    oldMessages.reverse()
                    for message in oldMessages {
                        self.conversations.append(message)
                    }
                    self.chatTableView.reloadData()
                case .failure(let error):
                    debug(error)
                }
            })
            
            debug("start reload data")
            self.fetchingMore = false
            self.chatTableView.reloadData()
        })
    }
    
    @objc private func keyboardWillAppear() {
        inputImageName = "lol"
        stickerViewHeight.constant = 0
        inputButton.setImage(UIImage(named: inputImageName), for: .normal)
    }
    
    @objc private func keyboardWillDisappear() {
        inputImageName = "keyboard-white"
        inputButton.setImage(UIImage(named: inputImageName), for: .normal)
    }
}

extension ChatViewController: UITableViewDelegate {
 
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            debug("up")
            messageTextField.resignFirstResponder()
        } else {
            debug("down")
            messageTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return conversations.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "indicatorCell", for: indexPath) as! IndicatorTableViewCell
            cell.startSpinning()
            return cell
        }
        
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
