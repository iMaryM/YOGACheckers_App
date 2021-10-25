//
//  GetPossibleCellToMove.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 25.10.21.
//

import UIKit

extension CheckersViewController {
    //функция для определения шашки которая должна бить (возвращает массив шашек, которые должны бить)
    func getCellWithCheckerNeedToFight () -> [Cell] {
        
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
                
                //находим клетки, в которые шашки могу ходить, которые реально существую на доске
                let nextCellsToMove = arrayOfCells.filter({$0.position == pointFreeCellRightS || $0.position == pointFreeCellLeftS || $0.position == pointFreeCellRightB || $0.position == pointFreeCellLeftB})
                
                if currentCheckerToMove == .white_checker {
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
                        
                        nextCellWithInverseChecker.forEach { nextCellWithInverseChecker in
                            if nextCellWithInverseChecker.position == pointFreeCellRightS {
                                nextPointsToMove.append(CGPoint(x: nextCellWithInverseChecker.position.x + (checkerBoard.frame.width / 8), y: nextCellWithInverseChecker.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if nextCellWithInverseChecker.position == pointFreeCellLeftS {
                                nextPointsToMove.append(CGPoint(x: nextCellWithInverseChecker.position.x - (checkerBoard.frame.width / 8), y: nextCellWithInverseChecker.position.y + (checkerBoard.frame.height / 8)))
                            }
                            if nextCellWithInverseChecker.position == pointFreeCellRightB {
                                nextPointsToMove.append(CGPoint(x: nextCellWithInverseChecker.position.x + (checkerBoard.frame.width / 8), y: nextCellWithInverseChecker.position.y - (checkerBoard.frame.height / 8)))
                            }
                            if nextCellWithInverseChecker.position == pointFreeCellLeftB {
                                nextPointsToMove.append(CGPoint(x: nextCellWithInverseChecker.position.x - (checkerBoard.frame.width / 8), y: nextCellWithInverseChecker.position.y - (checkerBoard.frame.height / 8)))
                            }
                        }
                        
                        //записываем пустые клеточки следующими за клетками с шашками противоположного цвета
                        for nextPoint in nextPointsToMove {
                            if !arrayOfCells.filter({($0.position == nextPoint) && ($0.checker == nil)}).isEmpty {
                                arrayCellsWithCheckersToFight.append(cell)
                            }
                        }
                    }
                    
                    if checker.color == .white_queen_checker {
                        
                        //находим точки клеток диагонали по которым может ходить дамки
                        var pointsOfDiagonalRightS = [CGPoint]()
                        var pointsOfDiagonalLeftS = [CGPoint]()
                        var pointsOfDiagonalRightB = [CGPoint]()
                        var pointsOfDiagonalLeftB = [CGPoint]()
                        
                        nextCellsToMove.forEach { nextCellToMove in
                            var iterator = 1
                            
                            if nextCellToMove.position == pointFreeCellRightS {
                                pointsOfDiagonalRightS.append(pointFreeCellRightS)
                                while iterator != 8 {
                                    pointsOfDiagonalRightS.append(CGPoint(x: nextCellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellLeftS {
                                pointsOfDiagonalLeftS.append(pointFreeCellLeftS)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftS.append(CGPoint(x: nextCellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellRightB {
                                pointsOfDiagonalRightB.append(pointFreeCellRightB)
                                while iterator != 8 {
                                    pointsOfDiagonalRightB.append(CGPoint(x: nextCellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellLeftB {
                                pointsOfDiagonalLeftB.append(pointFreeCellLeftB)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftB.append(CGPoint(x: nextCellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
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
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                                cellsOfDiagonalRightS.append(arrayOfCells.filter({$0.position == pointOfDiagonalRightS}).first!)
                            }
                        }
                        
                        for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                                cellsOfDiagonalLeftS.append(arrayOfCells.filter({$0.position == pointOfDiagonalLeftS}).first!)
                            }
                        }
                        
                        for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                                cellsOfDiagonalRightB.append(arrayOfCells.filter({$0.position == pointOfDiagonalRightB}).first!)
                            }
                        }
                        
                        for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                                cellsOfDiagonalLeftB.append(arrayOfCells.filter({$0.position == pointOfDiagonalLeftB}).first!)
                            }
                        }
                        
                        //проверяем каждую клеточку диагонали на наличие шашки противоположного цвета и пустой клеточки за ней
                        if !cellsOfDiagonalRightS.isEmpty {
                            
                            for cellOfDiagonalRightS in cellsOfDiagonalRightS {
                                //проверяем пустая ли следующая клетка
                                if cellOfDiagonalRightS.checker != nil {
                                    //проверяем цвет шашки в клеточке
                                    if (cellOfDiagonalRightS.checker?.color == .black_checker) || (cellOfDiagonalRightS.checker?.color == .black_queen_checker){
                                        //если шашка противоположного цвета то проверяем следующую клетку
                                        for nextCellOfDiagonalRightS in cellsOfDiagonalRightS {
                                            //находим следующую клетку
                                            if nextCellOfDiagonalRightS.position == CGPoint(x: cellOfDiagonalRightS.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightS.position.y + (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalRightS.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
                                            }
                                        }
                                    }
                                    //если в клетке шашка такого же цвета, то прерываем выполнение цикла
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
                                                if nextCellOfDiagonalLeftS.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
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
                                                if nextCellOfDiagonalRightB.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
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
                                        for nextCellOfDiagonalLeftB in cellsOfDiagonalLeftB {
                                            if nextCellOfDiagonalLeftB.position == CGPoint(x: cellOfDiagonalLeftB.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftB.position.y - (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalLeftB.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                    }
                }
                
                if currentCheckerToMove == .black_checker {
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
                    
                    if checker.color == .black_queen_checker {
                        
                        //находим точки клеток диагонали по которым может ходить дамки
                        var pointsOfDiagonalRightS = [CGPoint]()
                        var pointsOfDiagonalLeftS = [CGPoint]()
                        var pointsOfDiagonalRightB = [CGPoint]()
                        var pointsOfDiagonalLeftB = [CGPoint]()
                        
                        nextCellsToMove.forEach { nextCellToMove in
                            var iterator = 1
                            
                            if nextCellToMove.position == pointFreeCellRightS {
                                pointsOfDiagonalRightS.append(pointFreeCellRightS)
                                while iterator != 8 {
                                    pointsOfDiagonalRightS.append(CGPoint(x: nextCellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellLeftS {
                                pointsOfDiagonalLeftS.append(pointFreeCellLeftS)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftS.append(CGPoint(x: nextCellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y + (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellRightB {
                                pointsOfDiagonalRightB.append(pointFreeCellRightB)
                                while iterator != 8 {
                                    pointsOfDiagonalRightB.append(CGPoint(x: nextCellToMove.position.x + (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
                                    iterator += 1
                                }
                            }
                            
                            if nextCellToMove.position == pointFreeCellLeftB {
                                pointsOfDiagonalLeftB.append(pointFreeCellLeftB)
                                while iterator != 8 {
                                    pointsOfDiagonalLeftB.append(CGPoint(x: nextCellToMove.position.x - (checkerBoard.frame.width / 8) * CGFloat(iterator), y: nextCellToMove.position.y - (checkerBoard.frame.height / 8) * CGFloat(iterator)))
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
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalRightS}).isEmpty {
                                cellsOfDiagonalRightS.append(arrayOfCells.filter({$0.position == pointOfDiagonalRightS}).first!)
                            }
                        }
                        
                        for pointOfDiagonalLeftS in pointsOfDiagonalLeftS {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalLeftS}).isEmpty {
                                cellsOfDiagonalLeftS.append(arrayOfCells.filter({$0.position == pointOfDiagonalLeftS}).first!)
                            }
                        }
                        
                        for pointOfDiagonalRightB in pointsOfDiagonalRightB {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalRightB}).isEmpty {
                                cellsOfDiagonalRightB.append(arrayOfCells.filter({$0.position == pointOfDiagonalRightB}).first!)
                            }
                        }
                        
                        for pointOfDiagonalLeftB in pointsOfDiagonalLeftB {
                            if !arrayOfCells.filter({$0.position == pointOfDiagonalLeftB}).isEmpty {
                                cellsOfDiagonalLeftB.append(arrayOfCells.filter({$0.position == pointOfDiagonalLeftB}).first!)
                            }
                        }
                        
                        //проверяем каждую клеточку диагонали на наличие шашки противоположного цвета и пустой клеточки за ней
                        if !cellsOfDiagonalRightS.isEmpty {
                            
                            for cellOfDiagonalRightS in cellsOfDiagonalRightS {
                                //проверяем пустая ли следующая клетка
                                if cellOfDiagonalRightS.checker != nil {
                                    //проверяем цвет шашки в клеточке
                                    if (cellOfDiagonalRightS.checker?.color == .white_checker) || (cellOfDiagonalRightS.checker?.color == .white_queen_checker){
                                        //если шашка противоположного цвета то проверяем следующую клетку
                                        for nextCellOfDiagonalRightS in cellsOfDiagonalRightS {
                                            //находим следующую клетку
                                            if nextCellOfDiagonalRightS.position == CGPoint(x: cellOfDiagonalRightS.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightS.position.y + (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalRightS.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
                                            }
                                        }
                                    }
                                    //если в клетке шашка такого же цвета, то прерываем выполнение цикла
                                    break
                                }
                            }
                            
                        }
                        
                        if !cellsOfDiagonalLeftS.isEmpty {
                            for cellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                                if cellOfDiagonalLeftS.checker != nil {
                                    if (cellOfDiagonalLeftS.checker?.color == .white_checker) || (cellOfDiagonalLeftS.checker?.color == .white_queen_checker){
                                        for nextCellOfDiagonalLeftS in cellsOfDiagonalLeftS {
                                            if nextCellOfDiagonalLeftS.position == CGPoint(x: cellOfDiagonalLeftS.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftS.position.y + (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalLeftS.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
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
                                    if (cellOfDiagonalRightB.checker?.color == .white_checker) || (cellOfDiagonalRightB.checker?.color == .white_queen_checker){
                                        for nextCellOfDiagonalRightB in cellsOfDiagonalRightB {
                                            if nextCellOfDiagonalRightB.position == CGPoint(x: cellOfDiagonalRightB.position.x + (checkerBoard.frame.width / 8), y: cellOfDiagonalRightB.position.y - (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalRightB.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
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
                                    if (cellOfDiagonalLeftB.checker?.color == .white_checker) || (cellOfDiagonalLeftB.checker?.color == .white_queen_checker){
                                        for nextCellOfDiagonalLeftB in cellsOfDiagonalLeftB {
                                            if nextCellOfDiagonalLeftB.position == CGPoint(x: cellOfDiagonalLeftB.position.x - (checkerBoard.frame.width / 8), y: cellOfDiagonalLeftB.position.y - (checkerBoard.frame.height / 8)) {
                                                if nextCellOfDiagonalLeftB.checker == nil {
                                                    arrayCellsWithCheckersToFight.append(cell)
                                                }
                                                break
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
        }
        return arrayCellsWithCheckersToFight
    }
}
