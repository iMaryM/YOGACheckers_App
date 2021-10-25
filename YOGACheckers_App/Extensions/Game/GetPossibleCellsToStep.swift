//
//  GetPossibleCellsToStep.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 25.10.21.
//

import UIKit
import CoreMedia

extension CheckersViewController {
    //функция которая определяет клетки в которые можно ходить шашке, которая передана в cell и передан массив шашек которые должны бить
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
            
            //если текущий ход за белыми шашками
            if currentCheckerToMove == .white_checker {
                
                //простая белая шашка
                if cell.subviews.first?.tag == Checker_color.white_checker.rawValue {
                    if !cellsToMove.filter({$0.position == pointFreeCellRight_SW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_SW))
                    }
                    
                    if !cellsToMove.filter({$0.position == pointFreeCellLeft_SW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_SW))
                    }
                }
                
                //белая шашка-дамка
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
                    
                    //находим клетки диагонали на доске по которым могут ходить дамки
                    var cellsOfDiagonalRightS = [Cell]()
                    var cellsOfDiagonalLeftS = [Cell]()
                    var cellsOfDiagonalRightB = [Cell]()
                    var cellsOfDiagonalLeftB = [Cell]()
                    
                    for pointOfDiagonalRightS in pointsOfDiagonalRightS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                            cellsOfDiagonalRightS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                            cellsOfDiagonalLeftS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                            cellsOfDiagonalRightB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                            cellsOfDiagonalLeftB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).first!)
                        }
                    }
                    
                    //проверяем каждую клеточку дигонали на наличие шашки противоположного цвета и пустой клеточки за ней
                    if !cellsOfDiagonalRightS.isEmpty {
                        
                        for cellOfDiagonalRightS in cellsOfDiagonalRightS {
                            //проверяем пустая ли следующая клетка
                            if cellOfDiagonalRightS.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalRightS.position))
                            } else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftS.isEmpty {
                        for cellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                            if cellOfDiagonalLeftS.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalLeftS.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalRightB.isEmpty {
                        for cellOfDiagonalRightB in cellsOfDiagonalRightB {
                            if cellOfDiagonalRightB.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalRightB.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftB.isEmpty {
                        for cellOfDiagonalLeftB in cellsOfDiagonalLeftB {
                            if cellOfDiagonalLeftB.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalLeftB.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                }
                
            }
            
            //если текущий ход за черными шашками
            if currentCheckerToMove == .black_checker {
                
                //простые черные шашки
                if cell.subviews.first?.tag == Checker_color.black_checker.rawValue {
                    if !cellsToMove.filter({$0.position == pointFreeCellRight_BW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_BW))
                    }
                    
                    if !cellsToMove.filter({$0.position == pointFreeCellLeft_BW}).isEmpty {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_BW))
                    }
                }
                
                //черные шашки-дамки
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
                    
                    //находим клетки диагонали на доске по которым могут ходить дамки
                    var cellsOfDiagonalRightS = [Cell]()
                    var cellsOfDiagonalLeftS = [Cell]()
                    var cellsOfDiagonalRightB = [Cell]()
                    var cellsOfDiagonalLeftB = [Cell]()
                    
                    for pointOfDiagonalRightS in pointsOfDiagonalRightS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                            cellsOfDiagonalRightS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                            cellsOfDiagonalLeftS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                            cellsOfDiagonalRightB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                            cellsOfDiagonalLeftB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).first!)
                        }
                    }
                    
                    //проверяем каждую клеточку дигонали на наличие шашки противоположного цвета и пустой клеточки за ней
                    if !cellsOfDiagonalRightS.isEmpty {
                        
                        for cellOfDiagonalRightS in cellsOfDiagonalRightS {
                            //проверяем пустая ли следующая клетка
                            if cellOfDiagonalRightS.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalRightS.position))
                            } else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftS.isEmpty {
                        for cellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                            if cellOfDiagonalLeftS.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalLeftS.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalRightB.isEmpty {
                        for cellOfDiagonalRightB in cellsOfDiagonalRightB {
                            if cellOfDiagonalRightB.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalRightB.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftB.isEmpty {
                        for cellOfDiagonalLeftB in cellsOfDiagonalLeftB {
                            if cellOfDiagonalLeftB.checker == nil {
                                arrayOfPoints.append((fightCellPoint: nil, newCell: cellOfDiagonalLeftB.position))
                            }  else {
                                break
                            }
                        }
                    }
                    
                }
                
            }
            
        // если шашка должна обязательно бить
        } else {
            //если текущий ход за белыми шашками
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
                
                    //находим клетки диагонали на доске по которым могут ходить дамки
                    var cellsOfDiagonalRightS = [Cell]()
                    var cellsOfDiagonalLeftS = [Cell]()
                    var cellsOfDiagonalRightB = [Cell]()
                    var cellsOfDiagonalLeftB = [Cell]()
                    
                    for pointOfDiagonalRightS in pointsOfDiagonalRightS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                            cellsOfDiagonalRightS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                            cellsOfDiagonalLeftS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                            cellsOfDiagonalRightB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                            cellsOfDiagonalLeftB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).first!)
                        }
                    }
                    
                    //проверяем каждую клеточку дигонали на наличие шашки противоположного цвета и пустой клеточки за ней
                    if !cellsOfDiagonalRightS.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalRightS) in cellsOfDiagonalRightS.enumerated() {
                            if cellOfDiagonalRightS.checker != nil {
                                if (cellOfDiagonalRightS.checker?.color == .black_checker) || (cellOfDiagonalRightS.checker?.color == .black_queen_checker){
                                    if index != cellsOfDiagonalRightS.count - 1{
                                        if cellsOfDiagonalRightS[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightS.position, newCell: cellsOfDiagonalRightS[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalRightS.count) {
                                                if cellsOfDiagonalRightS[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightS.position, newCell: cellsOfDiagonalRightS[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftS.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalLeftS) in cellsOfDiagonalLeftS.enumerated() {
                            if cellOfDiagonalLeftS.checker != nil {
                                if (cellOfDiagonalLeftS.checker?.color == .black_checker) || (cellOfDiagonalLeftS.checker?.color == .black_queen_checker){
                                    if index != cellsOfDiagonalLeftS.count - 1{
                                        if cellsOfDiagonalLeftS[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftS.position, newCell: cellsOfDiagonalLeftS[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalLeftS.count) {
                                                if cellsOfDiagonalLeftS[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftS.position, newCell: cellsOfDiagonalLeftS[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalRightB.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalRightB) in cellsOfDiagonalRightB.enumerated() {
                            if cellOfDiagonalRightB.checker != nil {
                                if (cellOfDiagonalRightB.checker?.color == .black_checker) || (cellOfDiagonalRightB.checker?.color == .black_queen_checker){
                                    if index != cellsOfDiagonalRightB.count - 1{
                                        if cellsOfDiagonalRightB[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightB.position, newCell: cellsOfDiagonalRightB[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalRightB.count) {
                                                if cellsOfDiagonalRightB[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightB.position, newCell: cellsOfDiagonalRightB[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftB.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalLeftB) in cellsOfDiagonalLeftB.enumerated() {
                            if cellOfDiagonalLeftB.checker != nil {
                                if (cellOfDiagonalLeftB.checker?.color == .black_checker) || (cellOfDiagonalLeftB.checker?.color == .black_queen_checker){
                                    if index != cellsOfDiagonalLeftB.count - 1{
                                        if cellsOfDiagonalLeftB[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftB.position, newCell: cellsOfDiagonalLeftB[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalLeftB.count) {
                                                if cellsOfDiagonalLeftB[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftB.position, newCell: cellsOfDiagonalLeftB[index + iterator].position))
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                
                }
            }
            
            //если текущий ход за черными шашками
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
                
                    //находим клетки диагонали на доске по которым могут ходить дамки
                    var cellsOfDiagonalRightS = [Cell]()
                    var cellsOfDiagonalLeftS = [Cell]()
                    var cellsOfDiagonalRightB = [Cell]()
                    var cellsOfDiagonalLeftB = [Cell]()
                    
                    for pointOfDiagonalRightS in pointsOfDiagonalRightS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                            cellsOfDiagonalRightS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                            cellsOfDiagonalLeftS.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftS}).first!)
                        }
                    }
                    
                    for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                            cellsOfDiagonalRightB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalRightB}).first!)
                        }
                    }
                    
                    for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                        if !cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                            cellsOfDiagonalLeftB.append(cellsOfCheckerboard.filter({$0.position == pointOfDiagonalLeftB}).first!)
                        }
                    }
                    
                    //проверяем каждую клеточку дигонали на наличие шашки противоположного цвета и пустой клеточки за ней
                    if !cellsOfDiagonalRightS.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalRightS) in cellsOfDiagonalRightS.enumerated() {
                            if cellOfDiagonalRightS.checker != nil {
                                if (cellOfDiagonalRightS.checker?.color == .white_checker) || (cellOfDiagonalRightS.checker?.color == .white_queen_checker){
                                    if index != cellsOfDiagonalRightS.count - 1{
                                        if cellsOfDiagonalRightS[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightS.position, newCell: cellsOfDiagonalRightS[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalRightS.count) {
                                                if cellsOfDiagonalRightS[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightS.position, newCell: cellsOfDiagonalRightS[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftS.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalLeftS) in cellsOfDiagonalLeftS.enumerated() {
                            if cellOfDiagonalLeftS.checker != nil {
                                if (cellOfDiagonalLeftS.checker?.color == .white_checker) || (cellOfDiagonalLeftS.checker?.color == .white_queen_checker){
                                    if index != cellsOfDiagonalLeftS.count - 1{
                                        if cellsOfDiagonalLeftS[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftS.position, newCell: cellsOfDiagonalLeftS[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalLeftS.count) {
                                                if cellsOfDiagonalLeftS[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftS.position, newCell: cellsOfDiagonalLeftS[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalRightB.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalRightB) in cellsOfDiagonalRightB.enumerated() {
                            if cellOfDiagonalRightB.checker != nil {
                                if (cellOfDiagonalRightB.checker?.color == .white_checker) || (cellOfDiagonalRightB.checker?.color == .white_queen_checker){
                                    if index != cellsOfDiagonalRightB.count - 1{
                                        if cellsOfDiagonalRightB[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightB.position, newCell: cellsOfDiagonalRightB[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalRightB.count) {
                                                if cellsOfDiagonalRightB[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalRightB.position, newCell: cellsOfDiagonalRightB[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                    if !cellsOfDiagonalLeftB.isEmpty {
                        var iterator = 2
                        for (index, cellOfDiagonalLeftB) in cellsOfDiagonalLeftB.enumerated() {
                            if cellOfDiagonalLeftB.checker != nil {
                                if (cellOfDiagonalLeftB.checker?.color == .white_checker) || (cellOfDiagonalLeftB.checker?.color == .white_queen_checker){
                                    if index != cellsOfDiagonalLeftB.count - 1{
                                        if cellsOfDiagonalLeftB[index + 1].checker == nil {
                                            arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftB.position, newCell: cellsOfDiagonalLeftB[index + 1].position))
                                            while (index + iterator != cellsOfDiagonalLeftB.count) {
                                                if cellsOfDiagonalLeftB[index + iterator].checker == nil {
                                                    arrayOfPoints.append((fightCellPoint: cellOfDiagonalLeftB.position, newCell: cellsOfDiagonalLeftB[index + iterator].position))
                                                    
                                                }
                                                iterator += 1
                                            }
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                    
                }
            }
            
        }
        
        return arrayOfPoints
        
    }
}
