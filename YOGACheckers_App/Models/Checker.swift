//
//  Checker.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

class Checker: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var imageName: String?
    var color: Checker_color = .white_checker
    
    var image: UIImage? {
        return UIImage(named: self.imageName!)
    }
    
    init(imageName: String, color: Int) {
        self.imageName = imageName
        if let color = Checker_color(rawValue: color) {
            self.color = color
        }
    }
    
    override init() {
        super.init()
    }
    
    func encode(with coder: NSCoder) { //кодируем данные
        coder.encode(imageName, forKey: KeyesForFile.checkerImage.rawValue)
        coder.encode(color.rawValue, forKey: KeyesForFile.checkerColor.rawValue)
    }
    
    required init?(coder: NSCoder) {//раскодируем данные
        self.imageName = coder.decodeObject(forKey: KeyesForFile.checkerImage.rawValue) as? String ?? ""
        if let color = Checker_color(rawValue: coder.decodeInteger(forKey: KeyesForFile.checkerColor.rawValue)) {
            self.color = color
        }
    }
}
