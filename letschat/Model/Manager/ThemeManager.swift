//
//  ThemeManager.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager{
   
    static let shared  = ThemeManager()
    var testing = Theme.black
    
    public func switchTheme(callback: (Theme) -> () ){
        switch testing {
        case .black:
            testing = Theme.white
        case .white:
            testing = Theme.minion
        case .minion:
            testing = Theme.black
        }
        callback(testing)
        
    }
    
    public func setTheme(_ theme: Theme) {
         UserDefaults.standard.set(theme.rawValue, forKey: Config.theme)
    }
    
    public func getTheme() -> Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: Config.theme))!
    }
    
    public func getThemeName() -> String {
        return UserDefaults.standard.string(forKey: Config.name) ?? "Dark Vader"
    }
    
    public func setThemeName(_ name: String){
        UserDefaults.standard.set(name, forKey: Config.name)
    }
    
    public static func changeTo(_ theme: Theme, handler: (UIColor, UIColor) -> () ){
        var primaryColor = UIColor.ThemeColor.black
        var secondaryColor = UIColor.ThemeColor.white
        
        switch theme {
        case .black:
            print("handle black theme in login screen")
            primaryColor = UIColor.ThemeColor.black
            secondaryColor = UIColor.ThemeColor.white
            
        case .white:
            print("handle white  theme in login screen")
            primaryColor = UIColor.ThemeColor.white
            secondaryColor = UIColor.ThemeColor.purple
            
        case .minion:
            print("handle minion theme in login screen")
            primaryColor = UIColor.ThemeColor.yellow
            secondaryColor = UIColor.ThemeColor.blue
        }
        handler(primaryColor, secondaryColor)
    }
}

protocol ThemeManagerProtocol {
    func changeThemeTo(_ theme: Theme)
}


