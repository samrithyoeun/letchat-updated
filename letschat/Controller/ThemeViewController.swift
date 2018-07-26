//
//  ThemeViewController.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class ThemeViewController: UITableViewController {

    @IBOutlet weak var darkThemeImageView: UIImageView!
    @IBOutlet weak var whiteThemeImageView: UIImageView!
    @IBOutlet weak var minnionThemeImageView: UIImageView!
    
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var darkLabel: UILabel!
    @IBOutlet weak var primaryDarkLabel: UILabel!
    @IBOutlet weak var secondaryDarkLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var whitePrimaryLabel: UILabel!
    @IBOutlet weak var whiteSecondaryLabel: UILabel!
    @IBOutlet weak var minonLabel: UILabel!
    @IBOutlet weak var primaryMinionLabel: UILabel!
    @IBOutlet weak var secondaryMinnionLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellViewTwo: UIView!
    @IBOutlet weak var cellViewThree: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lineHeaderView: UIView!
    
    lazy var buttonGroup = [themeButton, saveButton]
    lazy var themeLabelGroup = [darkLabel, whiteLabel, minonLabel]
    lazy var checkBoxGroup = [darkThemeImageView, whiteThemeImageView, minnionThemeImageView]
    lazy var labelGroup = [darkLabel, primaryDarkLabel, secondaryDarkLabel, whiteLabel, whitePrimaryLabel, whiteSecondaryLabel, minonLabel, primaryMinionLabel, secondaryMinnionLabel]
    lazy var celLViewGroup = [cellView, cellViewThree, cellViewTwo,headerView,view]
    
    var selectedIndex = ThemeManager.shared.getTheme().rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.getTheme()
        changeThemeTo(theme)
        setCheckBox(index: theme.rawValue)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        debug("button tapped")
        ThemeManager.shared.setTheme(Theme(rawValue: selectedIndex)!)
        ThemeManager.shared.setThemeName((themeLabelGroup[selectedIndex]?.text)!)
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func themeButtonTapped(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    private func setCheckBox(index: Int) {
        for checkbox in checkBoxGroup {
            checkbox?.isHidden = true
        }
        
        checkBoxGroup[index]?.isHidden = false
    }
}

extension ThemeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        setCheckBox(index: index)
        changeThemeTo(Theme(rawValue: index)!)
        selectedIndex = index
    }
}

extension ThemeViewController: ThemeManagerProtocol {
    func changeThemeTo(_ theme: Theme) {
        ThemeManager.changeTo(theme) { (firstColor, secondColor) in
            for mView in celLViewGroup {
                mView?.backgroundColor = firstColor
            }
            
            for button in buttonGroup {
                button?.setTitleColor(secondColor, for: .normal)
            }
            themeButton.imageView?.tintColor = secondColor
            
            for checkbox in checkBoxGroup {
                checkbox?.tintColor = secondColor
            }
            
            for label in labelGroup {
                label?.textColor = secondColor
            }
            
            lineHeaderView.backgroundColor = secondColor
            
        }
    }
    
}
