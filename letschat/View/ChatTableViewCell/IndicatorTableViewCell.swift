//
//  IndicatorTableViewCell.swift
//  letschat
//
//  Created by Samrith Yoeun on 7/26/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class IndicatorTableViewCell: TemplateTableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public func startSpinning(){
        super.spinners = self.spinner
        spinner.startAnimating()
        super.contentsView = self.contentView
        super.handleThemeChange()
        
    }
    
    override func bindDataFrom(_ message: Message) {
        fatalError("Must Override")
    }
}
