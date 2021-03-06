//
//  SettingViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/23/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var soundButton: UIButton!
   
    @IBOutlet weak var settingMenuLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var themeChooserImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var themeSelectedLabel: UILabel!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var leaveView: UIView!
    @IBOutlet weak var themeCellView: UIView!
    @IBOutlet weak var soundCellView: UIView!
    @IBOutlet weak var themeLabel: UILabel!
    
    var soundButtonTrigger = true
    
    lazy var buttonGroup = [soundButton, closeButton, leaveGroupButton]
    lazy var labelGroup = [themeLabel, settingMenuLabel, soundLabel, themeLabel, themeSelectedLabel]
    lazy var viewGroup = [themeCellView, soundCellView, view, headerView, leaveView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
        ControllerManager.shared.setting = self
        
        soundButtonTrigger = UserDefaults.standard.bool(forKey: Config.sound)
        if soundButtonTrigger == false {
            soundButton.setImage(UIImage(named: "round"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(soundButtonTrigger, forKey: Config.sound)
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        if soundButtonTrigger == false {
            soundButton.setImage(UIImage(named: "checked"), for: .normal)
            soundButtonTrigger = true
        } else {
            soundButtonTrigger = false
            soundButton.setImage(UIImage(named: "round"), for: .normal)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leaveGroupButtonTapped(_ sender: UIButton) {
        SocketIOManager.shared.leaveGroup()
        debug("leaveGroup")
    }
    
    private func refreshUI(){
        let theme = ThemeManager.shared.getTheme()
        let name  = ThemeManager.shared.getThemeName()
        themeSelectedLabel.text = name
        changeThemeTo(theme)
    }
    
}

extension SettingViewController: ThemeManagerProtocol {
    func changeThemeTo(_ theme: Theme) {
        ThemeManager.changeTo(theme) { (firstColor, secondColor) in
            for mView in viewGroup {
                mView?.backgroundColor = firstColor
            }
            
            for button in buttonGroup {
                button?.setTitleColor(secondColor, for: .normal)
            }
            soundButton.imageView?.tintColor = secondColor
            themeChooserImageView.tintColor = secondColor
            
            for label in labelGroup {
                label?.textColor = secondColor
            }
            lineView.backgroundColor = secondColor
            
        }
    }
    
    
}
