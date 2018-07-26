//
//  ViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLineView: UIView!
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelButton: UIButton!
    @IBOutlet weak var channelLineView: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var channelDropDownImageView: UIImageView!
    
    lazy var imageViewGroup = [userImageView, channelImageView, channelDropDownImageView]
    lazy var viewGroup = [usernameLineView, channelLineView]
    lazy var labelGroup = [logoLabel, nameLabel, channelLabel]
    
    var channels = [Channel]()
    var actionSheet: UIAlertController!
    lazy var selectedChannelId = channels[0].id
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ControllerManager.shared.login = self
        changeThemeTo(Theme.black)
        
        joinButton.isEnabled = false
        usernameTextField.delegate = self
        getChannel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
    }
    
    @IBAction func channelButtonTapped(_ sender: UIButton) {
        actionSheet = UIAlertController(title: nil, message: "Select your Channel", preferredStyle: UIAlertControllerStyle.actionSheet)
        for channel in channels {
            let channelAction = UIAlertAction(title: channel.getLabel(), style: .default) { (alert: UIAlertAction) in
                self.channelButton.setTitle(channel.getLabel(), for: .normal)
                self.selectedChannelId = channel.id
                self.setSelectedChannel(channel.id, callback: {})
            }
            actionSheet.addAction(channelAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func joinButtontTapped(_ sender: UIButton) {
        self.goToChatScreen()
    }
    
    private func setSelectedChannel(_ id: String, callback: @escaping ()->()) {
        print("==set selected channel===")
        let params: [String: Any] = ["username": self.usernameTextField.text ?? "", "channelId": id]
        APIRequest.postRequest(endPoint: "/users", headers: [:], parameters: params, callback: { (json, code, error) in
            if error == nil {
                var user = User()
                user.setData(json)
                self.joinButton.isEnabled = true
                Channel.setChannelId(user.channelId)
                User.setUserId(user.id)
                callback()
            } else {
                print(error!)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "We are sorry!", message: "username is taken, please change!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.joinButton.isEnabled = false
                    callback()
                }
            }
            
            print(code ?? "")
            
        })
    }
    
    private func getChannel(){
        APIRequest.get(endPoint: "/channels") { (json, cod, error) in
            if error == nil {
                if let channels = Channel.getChannels(json) {
                    self.channels = channels
                    self.channelButton.setTitle(channels[0].getLabel(), for: .normal)
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    private func goToChatScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController {
            self.present(chatVC, animated: true) {
                ControllerManager.shared.chat = chatVC
            }
        } else {
            print("cannot get the chat VC from storyboard")
        }
    }
}

extension LoginViewController: ThemeManagerProtocol {
    func changeThemeTo(_ theme: Theme){
        ThemeManager.changeTo(theme) { (primaryColor, secondaryColor) in
            for mView in viewGroup {
                mView?.backgroundColor = secondaryColor
            }
            
            containerView.backgroundColor = primaryColor
            view.backgroundColor = primaryColor
            
            for label in labelGroup {
                label?.textColor = secondaryColor
            }
            
            for image in imageViewGroup {
                image?.tintColor = secondaryColor
            }
            
            usernameTextField.textColor = secondaryColor
            usernameTextField.setPlaceHolderColor(secondaryColor)
            
            channelButton.setTitleColor(secondaryColor, for: .normal)
            
            joinButton.backgroundColor = secondaryColor
            joinButton.setTitleColor(primaryColor, for: .normal)
        }
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setSelectedChannel(selectedChannelId, callback: {})
        usernameTextField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("start editing")
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 100, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("stop editing")
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 100, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
}
