//
//  ResultTableViewCell.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 11.10.21.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkerImagePlayer1: UIImageView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var checkerImagePlayer2: UIImageView!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var countPlayer1: UILabel!
    @IBOutlet weak var countPlayer2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(result_m: Results_m) {
        dateLabel.text = result_m.date_of_win
        checkerImagePlayer1.image = UIImage(named: result_m.checker_image_player_1 ?? "")
        player1Label.text = result_m.player_1
        checkerImagePlayer2.image = UIImage(named: result_m.checker_image_player_2 ?? "")
        player2Label.text = result_m.player_2
        
        if result_m.winner == player1Label.text {
            countPlayer1.text = "1"
        } else {
            countPlayer2.text = "1"
        }
    }
    
}
