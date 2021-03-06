//
//  OutGoingMessageTableViewCell.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class OutGoingMessageTableViewCell: TemplateTableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    
    override func bindDataFrom(_ message: Message) {
        super.contentsView = self.contentView
        super.userLabel = userInfoLabel
        super.messagesLabel = messageLabel
        super.setMessage(message)
        super.handleThemeChange()
    }
    
}
