//
//  GetPossibleCellsToStep.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 25.10.21.
//

import UIKit

extension CheckersViewController {
    //функция которая определяет клетки в которые можно ходить
    func getPossibleCellSteps(cell: UIView, arryaOfFightCells: [Cell]) -> [(fightCellPoint: CGPoint?, newCell: CGPoint)] {
        
        var arrayOfPoints: [(fightCellPoint: CGPoint?, newCell: CGPoint)] = []
        let cellsOfCheckerboard = createArryaOfCells()
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек ВПЕРЕД
        let pointFreeCellRight_SW = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
        let pointFreeCellLeft_SW = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек НАЗАД
        let pointFreeCellRight_BW = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
        let pointFreeCellLeft_BW = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
        
        //находим координаты клеточек в котрые может быть сделан ударный ход для белых (вперед вправо, вперед влево, назад вправо, назад влево)
        
        //вправо вниз
        let pointFightCellRight_SW = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        //влево вниз
        let pointFightCellLeft_SW = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        //вправо вверх
        let pointFightCellRight_BW = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        //влево вверх
        let pointFightCellLeft_BW = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        
        //находим клетки на доске, в которые шашки могут сделать ходить
        let cellsToMove = cellsOfCheckerboard.filter({$0.position == pointFreeCellRight_SW || $0.position == pointFreeCellLeft_SW || $0.position == pointFreeCellRight_BW || $0.position == pointFreeCellLeft_BW})
        
        
        // проверяем входит клеточка с которой взяли шашку в массив клеток в которых стоят шашки для битья
        // если не входит значит можно сделать свободный ход без битья
        if arryaOfFightCells.filter({$0.position == cell.frame.origin}).isEmpty {
            
            if currentCheckerToMove == Checker_color.white_checker {
                if cell.subviews.first?.tag == Checker_color.white_checker.rawValue {
                    if !cellsToMove.filter({$0.position == pointFreeCellRight_SW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_SW))
                    }
                    
                    if !cellsToMove.filter({$0.position == pointFreeCellLeft_SW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_SW))
                    }
                }
                
                if cell.subviews.first?.tag == Checker_color.white_queen_checker.rawValue {
                    //находим точки клеток диагонали по которым может ходить дамки
                    var pointsOfDiagonalRightS = [CGPoint]()
                    var pointsOfDiagonalLeftS = [CGPoint]()
                    var pointsOfDiagonalRightB = [CGPoint]()
                    var pointsOfDiagonalLeftB = [CGPoint]()
                    
                    cellsToMove.forEach { cellToMove in
                        var iterator = 1
                        
                        if cellToMove.position == pointFreeCellRight_SW {
                            pointsOfDiagonalRightS.append(pointFreeCellRight_SW)
                            while iterator != 8 {
                                pointsOfDiagonalRightS.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_SW {
                            pointsOfDiagonalLeftS.append(pointFreeCellLeft_SW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftS.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellRight_BW {
                            pointsOfDiagonalRightB.append(pointFreeCellRight_BW)
                            while iterator != 8 {
                                pointsOfDiagonalRightB.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_BW {
                            pointsOfDiagonalLeftB.append(pointFreeCellLeft_BW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftB.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                    }
                    
                    //находим клетки диагонали по которым может ходить дамки
                    checkerBoard.subviews.forEach { cellOfCheckerBoard in
                        if !pointsOfDiagonalRightS.isEmpty {
                            if pointsOfDiagonalRightS.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalLeftS.isEmpty {
                            if pointsOfDiagonalLeftS.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalRightB.isEmpty {
                            if pointsOfDiagonalRightB.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalLeftB.isEmpty {
                            if pointsOfDiagonalLeftB.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                    }
                }
                
            } else {
                
                if cell.subviews.first?.tag == Checker_color.black_checker.rawValue {
                    if !cellsToMove.filter({$0.position == pointFreeCellRight_BW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_BW))
                    }
                    
                    if !cellsToMove.filter({$0.position == pointFreeCellLeft_BW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_BW))
                    }
                }
                
                if cell.subviews.first?.tag == Checker_color.black_queen_checker.rawValue {
                    
                    //находим точки клеток диагонали по которым может ходить дамки
                    var pointsOfDiagonalRightS = [CGPoint]()
                    var pointsOfDiagonalLeftS = [CGPoint]()
                    var pointsOfDiagonalRightB = [CGPoint]()
                    var pointsOfDiagonalLeftB = [CGPoint]()
                    
                    cellsToMove.forEach { cellToMove in
                        var iterator = 1
                        
                        if cellToMove.position == pointFreeCellRight_SW {
                            pointsOfDiagonalRightS.append(pointFreeCellRight_SW)
                            while iterator != 8 {
                                pointsOfDiagonalRightS.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_SW {
                            pointsOfDiagonalLeftS.append(pointFreeCellLeft_SW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftS.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellRight_BW {
                            pointsOfDiagonalRightB.append(pointFreeCellRight_BW)
                            while iterator != 8 {
                                pointsOfDiagonalRightB.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_BW {
                            pointsOfDiagonalLeftB.append(pointFreeCellLeft_BW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftB.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                    }
                    
                    //находим клетки диагонали по которым может ходить дамки
                    checkerBoard.subviews.forEach { cellOfCheckerBoard in
                        if !pointsOfDiagonalRightS.isEmpty {
                            if pointsOfDiagonalRightS.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalLeftS.isEmpty {
                            if pointsOfDiagonalLeftS.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalRightB.isEmpty {
                            if pointsOfDiagonalRightB.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                        if !pointsOfDiagonalLeftB.isEmpty {
                            if pointsOfDiagonalLeftB.contains(cellOfCheckerBoard.frame.origin) {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfCheckerBoard.frame.origin))
                            }
                        }
                    }
                }
                
            }
            
        // если шашка должна обязательно бить
        } else {
            
            if currentCheckerToMove == .white_checker {
                if cell.subviews.first?.tag == Checker_color.white_checker.rawValue {
                    
                    var nextCellWithInverseChecker = [Cell]()
                    
                    //находим клетки в которых стоят шашки другого цвета
                    cellsToMove.forEach { cellToMove in
                        if let checker = cellToMove.checker {
                            if checker.color == .black_checker || checker.color == .black_queen_checker {
                                nextCellWithInverseChecker.append(cellToMove)
                            }
                        }
                    }

                    //записываем пустые клеточки следующими за клетками с шашками противоположного цвета
                    for cellOfCheckerBoard in cellsOfCheckerboard {
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellRight_SW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellRight_SW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellRight_SW, newCell: pointFightCellRight_SW))
                            }
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellLeft_SW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellLeft_SW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_SW, newCell: pointFightCellLeft_SW))
                            }
                            
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellRight_BW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellRight_BW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellRight_BW, newCell: pointFightCellRight_BW))
                            }
                            
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellLeft_BW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellLeft_BW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_BW, newCell: pointFightCellLeft_BW))
                            }
                            
                        }
                    }
                    
                }
                
                if cell.subviews.first?.tag == Checker_color.white_queen_checker.rawValue {
                    
                    //находим точки клеток диагонали по которым может ходить дамки
                    var pointsOfDiagonalRightS = [CGPoint]()
                    var pointsOfDiagonalLeftS = [CGPoint]()
                    var pointsOfDiagonalRightB = [CGPoint]()
                    var pointsOfDiagonalLeftB = [CGPoint]()
                    
                    cellsToMove.forEach { cellToMove in
                        var iterator = 1
                        
                        if cellToMove.position == pointFreeCellRight_SW {
                            pointsOfDiagonalRightS.append(pointFreeCellRight_SW)
                            while iterator != 8 {
                                pointsOfDiagonalRightS.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_SW {
                            pointsOfDiagonalLeftS.append(pointFreeCellLeft_SW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftS.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellRight_BW {
                            pointsOfDiagonalRightB.append(pointFreeCellRight_BW)
                            while iterator != 8 {
                                pointsOfDiagonalRightB.append(CGPoint(x: cellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                        if cellToMove.position == pointFreeCellLeft_BW {
                            pointsOfDiagonalLeftB.append(pointFreeCellLeft_BW)
                            while iterator != 8 {
                                pointsOfDiagonalLeftB.append(CGPoint(x: cellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                iterator += 1
                            }
                        }
                    }
                
                    //находим клетки диагонали по которым может ходить дамки
                    var cellsOfDiagonalRightS = [Cell]()
                    var cellsOfDiagonalLeftS = [Cell]()
                    var cellsOfDiagonalRightB = [Cell]()
                    var cellsOfDiagonalLeftB = [Cell]()
                    
                    cellsOfCheckerboard.forEach { cell in
                        if !pointsOfDiagonalRightS.filter({$0 == cell.position}).isEmpty {
                            cellsOfDiagonalRightS.append(cell)
                        }
                        if !pointsOfDiagonalLeftS.filter({$0 == cell.position}).isEmpty {
                            cellsOfDiagonalLeftS.append(cell)
                        }
                        if !pointsOfDiagonalRightB.filter({$0 == cell.position}).isEmpty {
                            cellsOfDiagonalRightB.append(cell)
                        }
                        if !pointsOfDiagonalLeftB.filter({$0 == cell.position}).isEmpty {
                            cellsOfDiagonalLeftB.append(cell)
                        }
                    }
                    
                    //проверяем каждую клеточку на наличие шашки противоположного цвета и пустой клеточки за ней
                    if !cellsOfDiagonalRightS.isEmpty {
                        cellsOfDiagonalRightS.forEach { cellOfDiagonalRightS in
                            if (cellOfDiagonalRightS.checker != nil && cellOfDiagonalRightS.checker?.color == .black_checker) || (cellOfDiagonalRightS.checker != nil && cellOfDiagonalRightS.checker?.color == .black_queen_checker){
                                cellsOfDiagonalRightS.forEach { nextCellOfDiagonalRightS in
                                    if nextCellOfDiagonalRightS.position == CGPoint(x: cellOfDiagonalRightS.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightS.position.y + (checkerBoard.frame.height / 8)) {
                                        arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightS.position, newCell: nextCellOfDiagonalRightS.position))
                                    }
                                }
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftS.isEmpty {
                        cellsOfDiagonalLeftS.forEach { cellOfDiagonalLeftS in
                            if (cellOfDiagonalLeftS.checker != nil && cellOfDiagonalLeftS.checker?.color == .black_checker) || (cellOfDiagonalLeftS.checker != nil && cellOfDiagonalLeftS.checker?.color == .black_queen_checker){
                                cellsOfDiagonalLeftS.forEach { nextCellOfDiagonalLeftS in
                                    if nextCellOfDiagonalLeftS.position == CGPoint(x: cellOfDiagonalLeftS.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftS.position.y + (checkerBoard.frame.height / 8)) {
                                        arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftS.position, newCell: nextCellOfDiagonalLeftS.position))
                                    }
                                }
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalRightB.isEmpty {
                        cellsOfDiagonalRightB.forEach { cellOfDiagonalRightB in
                            if (cellOfDiagonalRightB.checker != nil && cellOfDiagonalRightB.checker?.color == .black_checker) || (cellOfDiagonalRightB.checker != nil && cellOfDiagonalRightB.checker?.color == .black_queen_checker){
                                cellsOfDiagonalRightB.forEach { nextCellOfDiagonalRightB in
                                    if nextCellOfDiagonalRightB.position == CGPoint(x: cellOfDiagonalRightB.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightB.position.y - (checkerBoard.frame.height / 8)) {
                                        arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightB.position, newCell: nextCellOfDiagonalRightB.position))
                                    }
                                }
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftB.isEmpty {
                        cellsOfDiagonalLeftB.forEach { cellOfDiagonalLeftB in
                            if (cellOfDiagonalLeftB.checker != nil && cellOfDiagonalLeftB.checker?.color == .black_checker) || (cellOfDiagonalLeftB.checker != nil && cellOfDiagonalLeftB.checker?.color == .black_queen_checker){
                                cellsOfDiagonalLeftB.forEach { nextCellOfDiagonalLeftB in
                                    if nextCellOfDiagonalLeftB.position == CGPoint(x: cellOfDiagonalLeftB.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftB.position.y - (checkerBoard.frame.height / 8)) {
                                        arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftB.position, newCell: nextCellOfDiagonalLeftB.position))
                                    }
                                }
                            }
                        }
                    }
                
                }
            }
            
            if currentCheckerToMove == .black_checker {

                if cell.subviews.first?.tag == Checker_color.black_checker.rawValue {
   
                    var nextCellWithInverseChecker = [Cell]()
                    
                    //находим клетки в которых стоят шашки другого цвета
                    cellsToMove.forEach { cellToMove in
                        if let checker = cellToMove.checker {
                            if checker.color == .white_checker || checker.color == .white_queen_checker {
                                nextCellWithInverseChecker.append(cellToMove)
                            }
                        }
                    }

                    //записываем пустые клеточки следующими за клетками с шашками противоположного цвета
                    for cellOfCheckerBoard in cellsOfCheckerboard {
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellRight_SW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellRight_SW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellRight_SW, newCell: pointFightCellRight_SW))
                            }
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellLeft_SW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellLeft_SW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_SW, newCell: pointFightCellLeft_SW))
                            }
                            
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellRight_BW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellRight_BW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellRight_BW, newCell: pointFightCellRight_BW))
                            }
                            
                        }
                        if !nextCellWithInverseChecker.filter({$0.position == pointFreeCellLeft_BW}).isEmpty {
                            if cellOfCheckerBoard.position == pointFightCellLeft_BW && cellOfCheckerBoard.checker == nil {
                                arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_BW, newCell: pointFightCellLeft_BW))
                            }
                            
                        }
                    }
                }
                
                if cell.subviews.first?.tag == Checker_color.black_queen_checker.rawValue {
                    
                }
            }
            
        }
        
        return arrayOfPoints
        
    }
}
