//
//  LanguageTableViewCell.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 9.10.21.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(language: String, isChecked: Bool) {
        languageLabel.text = language
        checkedImageView.isHidden = isChecked
    }
    
}
