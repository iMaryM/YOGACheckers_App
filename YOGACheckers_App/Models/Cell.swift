//
//  Checker.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 12.08.21.
//

import UIKit

class Cell: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var imageName: String?
    var color: Int = 0
    var checker: Checker? = nil
    
    var image: UIImage? {
        return UIImage(named: self.imageName!)
    }
    
    init(position: CGPoint, imageName: String, color: Int) {
        self.position = position
        self.imageName = imageName
        self.color = color
    }
    
    override init() {
        super.init()
    }
    
    func addChecker(checker: Checker) {
        self.checker = checker
    }
    
    func encode(with coder: NSCoder) { //кодируем данные
        coder.encode(position, forKey: KeyesForFile.cellPosition.rawValue)
        coder.encode(imageName, forKey: KeyesForFile.cellImage.rawValue)
        coder.encode(color, forKey: KeyesForFile.cellColor.rawValue)
        coder.encode(checker, forKey: KeyesForFile.checker.rawValue)
    }
    
    required init?(coder: NSCoder) {//раскодируем данные
        self.position = coder.decodeCGPoint(forKey: KeyesForFile.cellPosition.rawValue)
        self.imageName = coder.decodeObject(forKey: KeyesForFile.cellImage.rawValue) as? String ?? ""
        self.color = coder.decodeInteger(forKey: KeyesForFile.cellColor.rawValue)
        self.checker = coder.decodeObject(forKey: KeyesForFile.checker.rawValue) as? Checker
    }
}
