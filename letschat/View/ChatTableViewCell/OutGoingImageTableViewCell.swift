//
//  OutGoingImageTableViewCell.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class OutGoingImageTableViewCell: TemplateTableViewCell {
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    
    override func bindDataFrom(_ message: Message) {
        super.contentsView = self.contentView
        super.userLabel = userInfoLabel
        super.stickerImageView = messageImageView
        super.setMessage(message)
        super.handleThemeChange()
    }
    
}
