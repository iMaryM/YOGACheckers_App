//
//  SettingsTableViewCell.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var nextViewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nextViewButton.imageView?.image = nextViewButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        nextViewButton.tintColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupSetting(setting: String) {
        settingNameLabel.text = setting
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    
}
