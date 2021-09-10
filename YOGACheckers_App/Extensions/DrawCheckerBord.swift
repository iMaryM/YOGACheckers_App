//
//  DrawElement.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

extension CheckersViewController {
    
    func drawCheckerboard() {
        //отрисовка рамочки для доски
        let checkerBoardBoarder = UIView(frame: CGRect(origin: .zero, size: CGSize(width: screenSize.width - 12, height: screenSize.width - 12)))
        checkerBoardBoarder.center = view.center
        checkerBoardBoarder.layer.borderWidth = 9
        checkerBoardBoarder.layer.borderColor = UIColor(red: 188 / 255, green: 169 / 255, blue: 137 / 255, alpha: 1).cgColor
        view.addSubview(checkerBoardBoarder)
        
        //отрисовка доски без клеточек
        checkerBoard = UIView(frame: CGRect(origin: .zero, size: CGSize(width: screenSize.width - 32, height: screenSize.width - 32)))
        checkerBoard.center = view.center
        view.addSubview(checkerBoard)
        
    }
    
    func drawCell() {
        let widthOfCurrentView = checkerBoard.frame.width / 8
        let heightOfCurrentView = checkerBoard.frame.height / 8
        
        var cellView = UIImageView()
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for i in 1...8 {
            x = 0
            for j in 1...8 {
                //отрисовка клеточки
                cellView = UIImageView(frame: CGRect(x: x, y: y, width: widthOfCurrentView, height: heightOfCurrentView))
                
                if (i + j) % 2 == 0 {
                    cellView.image = UIImage(named: "light_3")
                    cellView.tag = Cell_color.white_cell.rawValue
                } else {
                    cellView.image = UIImage(named: "dark_3")
                    cellView.tag = Cell_color.black_cell.rawValue
                }
                
                cellView.isUserInteractionEnabled = true
                
                checkerBoard.addSubview(cellView)
                arrayOfCellsViews.append(cellView)
                
                x += widthOfCurrentView
            }
            y += heightOfCurrentView
        }
    }
    
    func drawChecker() {
        let widthOfCurrentView = checkerBoard.frame.width / 8
        let heightOfCurrentView = checkerBoard.frame.height / 8
        
        var checkerView = UIImageView()
        
        for (index,value) in checkerBoard.subviews.enumerated(){
            if index < 24 || index > 39, value.tag == Cell_color.black_cell.rawValue {
                checkerView = UIImageView(frame: CGRect(x: 5, y: 5, width: widthOfCurrentView - 10, height: heightOfCurrentView - 10))
                
                if index < 24 {
                    checkerView.image = UIImage(named: (SettingsManager.shared.savedWhiteChecker)!)
                    checkerView.tag = Checker_color.white_checker.rawValue
                } else {
                    checkerView.image = UIImage(named: (SettingsManager.shared.savedBlackChecker)!)
                    checkerView.tag = Checker_color.black_checker.rawValue
                }
                
                checkerView.isUserInteractionEnabled = true
                
                value.addSubview(checkerView)
                arrayOfCheckersView.append(checkerView)
            }
        }
    }
    
    func drawCheckerFromFile() {
        let widthOfCurrentView = checkerBoard.frame.width / 8
        let heightOfCurrentView = checkerBoard.frame.height / 8
        
        var checkerView = UIImageView()
        
        for cell in checkerBoard.subviews {
            for cellWithChecker in cellsWithChecker {
                
                if cellWithChecker.position == cell.frame.origin {
                    
                    guard let checkerInCell = cellWithChecker.checker else {
                        return
                    }
                    
                    checkerView = UIImageView(frame: CGRect(x: 5, y: 5, width: widthOfCurrentView - 10, height: heightOfCurrentView - 10))
                    checkerView.tag = checkerInCell.color.rawValue
                    checkerView.image = UIImage(named: checkerInCell.imageName!)
                    checkerView.isUserInteractionEnabled = true
                    
                    cell.addSubview(checkerView)
                    arrayOfCheckersView.append(checkerView)
                }
            }
        }
    }
    
}
