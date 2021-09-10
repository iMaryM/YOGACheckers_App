//
//  UIViewController+Storyboard.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 26.07.21.
//

import UIKit

extension UIViewController {
    
    func getViewController (from storyBoard: String, and storyBoardID: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        let currentViewController = storyBoard.instantiateViewController(withIdentifier: storyBoardID)
        currentViewController.modalPresentationStyle = .fullScreen
        currentViewController.modalTransitionStyle = .crossDissolve
        return currentViewController
    }
    
    func decorationButton(button: UIView, color: UIColor, borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize, shadowOpacity: Float) {
        button.backgroundColor = color
        
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
        button.layer.cornerRadius = cornerRadius
        
        button.layer.shadowColor = shadowColor
        button.layer.shadowOffset = shadowOffset
        button.layer.shadowOpacity = shadowOpacity
    }
    
}

