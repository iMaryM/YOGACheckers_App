//
//  Results_m.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 11.10.21.
//

import UIKit

class Results_m {
    public var player_1: String?
    public var checker_image_player_1: String?
    public var player_2: String?
    public var checker_image_player_2: String?
    public var winner: String?
    public var date_of_win: String?
    public var duration: String?
    
    init(player_1: String?, checker_image_player_1: String?, player_2: String?, checker_image_player_2: String?, winner: String?, date_of_win: String?, duration: String?) {
        self.player_1 = player_1
        self.checker_image_player_1 = checker_image_player_1
        self.player_2 = player_2
        self.checker_image_player_2 = checker_image_player_2
        self.winner = winner
        self.date_of_win = date_of_win
        self.duration = duration
    }
}
