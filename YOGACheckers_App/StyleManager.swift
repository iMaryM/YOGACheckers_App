//
//  StyleManager.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 23.08.21.
//

import UIKit

class SteyleManager {
    
    static func setColor(color: Colors) -> UIColor {
        switch color {
        case .lightBlue:
            return UIColor(red: 154 / 255, green: 189 / 255, blue: 203 / 255, alpha: 1)
        case .mediumBlue:
            return UIColor(red: 84 / 255, green: 125 / 255, blue: 140 / 255, alpha: 1)
        case .darkBlue:
            return UIColor(red: 51 / 255, green: 69 / 255, blue: 80 / 255, alpha: 1)
        }
    }
    
}
