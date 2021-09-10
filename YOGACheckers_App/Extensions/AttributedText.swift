//
//  AttributedText.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

extension UIViewController{
    
    func addAtributedTextForTimer(for string: String) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key : Any] = [   .font : UIFont(name: "StyleScript-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        attrs = [
            .foregroundColor : SteyleManager.setColor(color: .darkBlue)]
        attributedString.addAttributes(attrs, range: _NSRange(location: 0, length: 2))
        
        attrs = [
            .foregroundColor : SteyleManager.setColor(color: .mediumBlue)]
        attributedString.addAttributes(attrs, range: _NSRange(location: 5, length: 2))
        
        attrs = [
            .foregroundColor : SteyleManager.setColor(color: .lightBlue)]
        attributedString.addAttributes(attrs, range: _NSRange(location: 10, length: 2))
        
        return attributedString
    }
    
    func addAtributedTextForDate(for string: String, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key : Any] = [
                                                        .font : UIFont(name: "StyleScript-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24),
                                                        .foregroundColor : color]
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        return attributedString
    }
    
}
