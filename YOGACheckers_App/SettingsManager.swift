//
//  SettingsManager.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 29.08.21.
//

import UIKit

class SettingsManager {
    static let shared = SettingsManager()
    
    var savedWhiteChecker: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.whiteCheckerImage.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.whiteCheckerImage.rawValue)
        }
    }
    
    var savedWhiteCheckerQueen: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.whiteCheckerQueenImage.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.whiteCheckerQueenImage.rawValue)
        }
    }
    
    var savedBlackChecker: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.blackCheckerImage.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.blackCheckerImage.rawValue)
        }
    }
    
    var savedBlackCheckerQueen: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.blackCheckerQueenImage.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.blackCheckerQueenImage.rawValue)
        }
    }
    
    var savedTimer: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.seconds.rawValue)
        }
        
        get {
            return UserDefaults.standard.integer(forKey: KeyesUserDefaults.seconds.rawValue)
        }
    }
    
    var savedDate: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.date.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.date.rawValue)
        }
    }
    
    var savedPlayerWhite: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.nameOfPlayerWhite.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.nameOfPlayerWhite.rawValue)
        }
    }
    
    var savedPlayerBlack: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.nameOfPlayerBlack.rawValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: KeyesUserDefaults.nameOfPlayerBlack.rawValue)
        }
    }
    
    var savedColorOfCheckerShouldBeMoved: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeyesUserDefaults.movedChecker.rawValue)
        }
        
        get {
            return UserDefaults.standard.integer(forKey: KeyesUserDefaults.movedChecker.rawValue)
        }
    }
    
    var savedCellsWithCheckers: [Cell] {
        set {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("savedGame")
            //записать в файл массив клеточек с шашками
            let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
            try? data?.write(to: fileURL)
        }
    
        get {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("savedGame")
            guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")),
                  let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Cell] else { return [] }
            return object
        }
    }
    
    var savedBackgroungOfCheckersView: Any {
        set {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("customSettings")
            
            try? FileManager.default.removeItem(at: fileURL)
            
            let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
            try? data?.write(to: fileURL)
            
        }
        
        get {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("customSettings")
            guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")),
                  let object = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data) else {
                
                return UIImage()
            }

            return object
        }
    }
    
}
