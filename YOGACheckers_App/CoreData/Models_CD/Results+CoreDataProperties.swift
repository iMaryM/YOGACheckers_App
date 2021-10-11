//
//  Results+CoreDataProperties.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 11.10.21.
//
//

import Foundation
import CoreData


extension Results {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Results> {
        return NSFetchRequest<Results>(entityName: "Results")
    }

    @NSManaged public var player_1: String?
    @NSManaged public var checker_image_player_1: String?
    @NSManaged public var player_2: String?
    @NSManaged public var checker_image_player_2: String?
    @NSManaged public var winner: String?
    @NSManaged public var date_of_win: String?
    @NSManaged public var duration: String?
    
    func convert(from results_m: Results_m) {
        self.player_1 = results_m.player_1
        self.checker_image_player_1 = results_m.checker_image_player_1
        self.player_2 = results_m.player_2
        self.checker_image_player_2 = results_m.checker_image_player_2
        self.winner = results_m.winner
        self.date_of_win = results_m.date_of_win
        self.duration = results_m.duration
    }
}

extension Results : Identifiable {

}
