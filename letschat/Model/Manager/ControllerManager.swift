//
//  ControllerManager.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

class ControllerManager {
    static let shared  = ControllerManager()
    var login: LoginViewController?
    var theme: ThemeViewController?
    var setting: SettingViewController?
    var chat: ChatViewController?
}
