//
//  TemplateTableViewCell.swift
//  let's chat
//
//  Created by Samrith Yoeun on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class TemplateTableViewCell: UITableViewCell {
    
    var userLabel: UILabel?
    var stickerImageView: UIImageView?
    var messagesLabel: UILabel?
    var contentsView: UIView?
    var spinners: UIActivityIndicatorView?
    
    public func setMessage(_ message: Message){
        userLabel?.text = message.username + " - " + message.time
        messagesLabel?.text = message.content
        stickerImageView?.image = UIImage(named: message.content)
        
    }
    
    public func handleThemeChange(){
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
    }
    
   func bindDataFrom(_ message: Message) {
         fatalError("Must Override")
    }
}

extension TemplateTableViewCell: ThemeManagerProtocol {
    func changeThemeTo(_ theme: Theme) {
        ThemeManager.changeTo(theme) { (firstColor, secondColor) in
            userLabel?.textColor = secondColor
            stickerImageView?.tintColor = secondColor
            contentsView?.backgroundColor = firstColor
            messagesLabel?.textColor = secondColor
            spinners?.tintColor = secondColor
            
        }
    }
    
}
