//
//  OnOffMusicTableViewCell.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 4.10.21.
//

import UIKit
import AVFoundation

class OnOffMusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var musicIsOnOff: UISwitch!
    @IBOutlet weak var musicLabel: UILabel!
    
    var musicPlayer: AVPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(player: AVPlayer?) {
        musicPlayer = player
        if SettingsManager.shared.musicOnOff == 0 {
            musicIsOnOff.isOn = true
        } else {
            musicIsOnOff.isOn = false
        }
    }
    
    @IBAction func valueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            SettingsManager.shared.musicOnOff = 0
            musicPlayer?.play()
        } else {
            SettingsManager.shared.musicOnOff = 1
            musicPlayer?.pause()
            musicPlayer?.seek(to: .zero)
        }
    }
    
}
