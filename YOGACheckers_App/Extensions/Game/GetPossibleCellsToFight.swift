//
//  GetPossibleCellToMove.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 25.10.21.
//

import UIKit

extension CheckersViewController {
    //функция для определения шашки которая должна бить
    func getCellWithCheckerNeedToFight (checkerColor: Checker_color) -> [Cell] {
        
        let arrayOfCells = createArryaOfCells()
        
        var arrayCellsWithCheckersToFight: [Cell] = []
        
        for cell in arrayOfCells {
            if let checker = cell.checker {
                
                //находим координаты клеточек в которых может быть сделан ход (свободный) ВПЕРЕД
                let pointFreeCellRightS = CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8))
                let pointFreeCellLeftS = CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8))
                
                //находим координаты клеточек в которых может быть сделан ход (свободный) НАЗАД
                let pointFreeCellRightB = CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8))
                let pointFreeCellLeftB = CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8))
                
                //находим клетки в которые шашки могут ходить
                let nextCellsToMove = arrayOfCells.filter({$0.position == pointFreeCellRightS || $0.position == pointFreeCellLeftS || $0.position == pointFreeCellRightB || $0.position == pointFreeCellLeftB})
                
                if checkerColor == .white_checker {
                    if checker.color == .white_queen_checker {
                        
                        //находим точки клеток диагонали по которым может ходить дамки
                        var pointsOfDiagonalRightS = [CGPoint]()
                        var pointsOfDiagonalLeftS = [CGPoint]()
                        var pointsOfDiagonalRightB = [CGPoint]()
                        var pointsOfDiagonalLeftB = [CGPoint]()
                        
                        nextCellsToMove.forEach { cell in
                            var iterator = 1
                            
                            if cell.position == pointFreeCellRightS {
                                pointsOfDiagonalRightS.append(pointFreeCellRightS)
                                while iterator != 8 {
                                    pointsOfDiagonalRightS.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellLeftS {
                                pointsOfDiagonalLeftS.append(pointFreeCellLeftS)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftS.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellRightB {
                                pointsOfDiagonalRightB.append(pointFreeCellRightB)
                                while iterator != 8 {
                                    pointsOfDiagonalRightB.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellLeftB {
                                pointsOfDiagonalLeftB.append(pointFreeCellLeftB)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftB.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                        }
                        
                        //находим клетки диагонали по которым может ходить дамки
                        var cellsOfDiagonalRightS = [Cell]()
                        var cellsOfDiagonalLeftS = [Cell]()
                        var cellsOfDiagonalRightB = [Cell]()
                        var cellsOfDiagonalLeftB = [Cell]()
                        
                        arrayOfCells.forEach { cell in
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
                            for cellOfDiagonalRightS in cellsOfDiagonalRightS {
                                if cellOfDiagonalRightS.checker != nil {
                                    if (cellOfDiagonalRightS.checker?.color == .black_checker) || (cellOfDiagonalRightS.checker?.color == .black_queen_checker){
                                        for nextCellOfDiagonalRightS in cellsOfDiagonalRightS {
                                            if nextCellOfDiagonalRightS.position == CGPoint(x: cellOfDiagonalRightS.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightS.position.y + (checkerBoard.frame.height / 8)) {
                                                arrayCellsWithCheckersToFight.append(cell)
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                        if !cellsOfDiagonalLeftS.isEmpty {
                            for cellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                                if cellOfDiagonalLeftS.checker != nil {
                                    if (cellOfDiagonalLeftS.checker?.color == .black_checker) || (cellOfDiagonalLeftS.checker?.color == .black_queen_checker){
                                        for nextCellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                                            if nextCellOfDiagonalLeftS.position == CGPoint(x: cellOfDiagonalLeftS.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftS.position.y + (checkerBoard.frame.height / 8)) {
                                                arrayCellsWithCheckersToFight.append(cell)
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                        if !cellsOfDiagonalRightB.isEmpty {
                            for cellOfDiagonalRightB in cellsOfDiagonalRightB {
                                if cellOfDiagonalRightB.checker != nil {
                                    if (cellOfDiagonalRightB.checker?.color == .black_checker) || (cellOfDiagonalRightB.checker?.color == .black_queen_checker){
                                        for nextCellOfDiagonalRightB in cellsOfDiagonalRightB {
                                            if nextCellOfDiagonalRightB.position == CGPoint(x: cellOfDiagonalRightB.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightB.position.y - (checkerBoard.frame.height / 8)) {
                                                arrayCellsWithCheckersToFight.append(cell)
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                        if !cellsOfDiagonalLeftB.isEmpty {
                            for cellOfDiagonalLeftB in cellsOfDiagonalLeftB {
                                if cellOfDiagonalLeftB.checker != nil {
                                    if (cellOfDiagonalLeftB.checker?.color == .black_checker) || (cellOfDiagonalLeftB.checker?.color == .black_queen_checker){
                                        cellsOfDiagonalLeftB.forEach { nextCellOfDiagonalLeftB in
                                            if nextCellOfDiagonalLeftB.position == CGPoint(x: cellOfDiagonalLeftB.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftB.position.y - (checkerBoard.frame.height / 8)) {
                                                arrayCellsWithCheckersToFight.append(cell)
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                    }
                    
                    if checker.color == .white_checker {
                        
                        //находим клетки в которых стоят шашки другого цвета
                        var nextCellWithInverseChecker = [Cell]()
                        
                        //находим клетки в которых стоят шашки другого цвета
                        nextCellsToMove.forEach { nextCellToMove in
                            if let checker = nextCellToMove.checker {
                                if checker.color == .black_checker || checker.color == .black_queen_checker {
                                    nextCellWithInverseChecker.append(nextCellToMove)
                                }
                            }
                        }
                        
                        //находим точки следующих клеточек
                        var nextPointsToMove = [CGPoint]()
                        
                        nextCellWithInverseChecker.forEach { cell in
                            if cell.position == pointFreeCellRightS {
                                nextPointsToMove.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellLeftS {
                                nextPointsToMove.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellRightB {
                                nextPointsToMove.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellLeftB {
                                nextPointsToMove.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8)))
                            }
                        }
                        
                        //записываем пустые клеточки следующими за клетками с шашками противоположного цвета
                        for nextPoint in nextPointsToMove {
                            if !arrayOfCells.filter({($0.position == nextPoint) && ($0.checker == nil)}).isEmpty {
                                arrayCellsWithCheckersToFight.append(cell)
                            }
                        }
                    }
                }
                
                if checkerColor == .black_checker {
                    if checker.color == .black_queen_checker {
                        //находим точки клеток диагонали по которым может ходить дамки
                        var pointsOfDiagonalRightS = [CGPoint]()
                        var pointsOfDiagonalLeftS = [CGPoint]()
                        var pointsOfDiagonalRightB = [CGPoint]()
                        var pointsOfDiagonalLeftB = [CGPoint]()
                        
                        nextCellsToMove.forEach { cell in
                            var iterator = 1
                            
                            if cell.position == pointFreeCellRightS {
                                pointsOfDiagonalRightS.append(pointFreeCellRightS)
                                while iterator != 8 {
                                    pointsOfDiagonalRightS.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellLeftS {
                                pointsOfDiagonalLeftS.append(pointFreeCellLeftS)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftS.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellRightB {
                                pointsOfDiagonalRightB.append(pointFreeCellRightB)
                                while iterator != 8 {
                                    pointsOfDiagonalRightB.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            if cell.position == pointFreeCellLeftB {
                                pointsOfDiagonalLeftB.append(pointFreeCellLeftB)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftB.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: cell.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                        }
                        
                        //находим клетки диагонали по которым может ходить дамки
                        var cellsOfDiagonalRightS = [Cell]()
                        var cellsOfDiagonalLeftS = [Cell]()
                        var cellsOfDiagonalRightB = [Cell]()
                        var cellsOfDiagonalLeftB = [Cell]()
                        
                        arrayOfCells.forEach { cell in
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
                                            arrayCellsWithCheckersToFight.append(cell)
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
                                            arrayCellsWithCheckersToFight.append(cell)
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
                                            arrayCellsWithCheckersToFight.append(cell)
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
                                            arrayCellsWithCheckersToFight.append(cell)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if checker.color == .black_checker {
                        
                        //находим клетки в которых стоят шашки другого цвета
                        let nextCellWithInverseChecker = nextCellsToMove.filter({($0.checker != nil) && ($0.checker?.color != checker.color)})
                        
                        //находим точки следующих клеточек
                        var nextPointsToMove = [CGPoint]()
                        
                        nextCellWithInverseChecker.forEach { cell in
                            if cell.position == pointFreeCellRightS {
                                nextPointsToMove.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellLeftS {
                                nextPointsToMove.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellRightB {
                                nextPointsToMove.append(CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8)))
                            }
                            if cell.position == pointFreeCellLeftB {
                                nextPointsToMove.append(CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8)))
                            }
                        }
                        
                        //записываем пустые клеточки следующими за клетками с шашками противоположного цвета
                        for nextPoint in nextPointsToMove {
                            if !arrayOfCells.filter({($0.position == nextPoint) && ($0.checker == nil)}).isEmpty {
                                arrayCellsWithCheckersToFight.append(cell)
                            }
                        }
                    }
                }
            }
        }
        return arrayCellsWithCheckersToFight
    }
}
