//
//  GameChecker.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 11.09.21.
//

import UIKit

extension CheckersViewController {
    
    @objc
    func tapGestureAction(_ sender: UILongPressGestureRecognizer) {
        guard let currentChecker = sender.view  else { return } //определяем шашку которую двигаем

        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                currentChecker.transform = currentChecker.transform.scaledBy(x: 1.2, y: 1.2)
            }
        case .ended:
            UIView.animate(withDuration: 0.3) {
                currentChecker.transform = .identity
            }
        default:
            break
        }
    }
    
    @objc
    func panGestureAction(_ sender: UIPanGestureRecognizer) {
        
        //проверяем цвет шашки
        guard let currentChecker = sender.view,
              currentChecker.tag == currentCheckerToMove.rawValue else {
            return
        }
 
        let location = sender.location(in: checkerBoard)
        
        let translation = sender.translation(in: checkerBoard)
        
        guard let currentView = sender.view?.superview, //определяем клеточку на которой стоит шашка
              let currentChecker = sender.view, //определяем шашку которую двигаем
              let defaultOrigin = sender.view?.frame.origin else { //определяем координаты шашки которую будем двигать
            return
        }
        
        //проверяем есть ли шашки которые должны обязательно побить
        let cellWhithCheckerNeedFight = getCellWithCheckerNeedToFight(checkerColor: currentCheckerToMove)
        
        if !cellWhithCheckerNeedFight.isEmpty {
            guard !cellWhithCheckerNeedFight.filter({$0.position == currentView.frame.origin}).isEmpty else { return }
        }

        let arrayOfPoints = possibleCellSteps(cell: currentView)

        switch sender.state {
        case .changed:
            checkerBoard.bringSubviewToFront(currentView) //передвигаем клеточку на передний план
            currentChecker.frame.origin = CGPoint(x: defaultOrigin.x + translation.x, y: defaultOrigin.y + translation.y) //передвигаем шашку относительно точки с которой сдвигаем
            sender.setTranslation(.zero, in: checkerBoard) //сбрасываем translation, чтобы всегда сдвиг был с нуля
        
        case .ended:
            var newCheckerView: UIView? = nil //клеточка в которую хотим поставить шашку
            
            //проверяем является ли клетка в которую хотим поставить шашку черной
            for value in arrayOfCellsViews {
                //проверяем входит ли в текущее местоположение шашки клеточка доски
                if value.frame.contains(location) {
                    //проверяем входит ли клетка в допустимы дипазон для пермещения
                    for point in arrayOfPoints {
                        if value.frame.contains(point) {
                            newCheckerView = value
                        }
                    }
                }
            }
            
            currentChecker.frame.origin = CGPoint(x: 5, y: 5) // сбрасываем позицию на 5;5 чтобы отцентрировать

            //проверяем есть ли в клеточке в которую хотим поставить шашку другая шашка
            guard let newCheckerView = newCheckerView, newCheckerView.subviews.isEmpty,
                  let checker = sender.view else {
                return }

            newCheckerView.addSubview(checker) // добавляем шашку на новую клетку
            
            UIView.animate(withDuration: 0.3) {
                checker.transform = .identity
            }
            
            currentCheckerToMove = currentCheckerToMove == .white_checker ? .black_checker : .white_checker
            
            if currentCheckerToMove == .white_checker {
                labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerWhite!)"
                currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedWhiteChecker!)
            } else {
                labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerBlack!)"
                currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedBlackChecker!)
            }
            
        default:
            break
        }
    }
    
    //функция для определения шашки которая должна бить
    func getCellWithCheckerNeedToFight (checkerColor: Checker_color) -> [Cell] {
        
        let arrayOfCells = createArryaOfCells()
        
        var arrayCellsWithCheckersToFight: [Cell] = []
        
        for cell in arrayOfCells {
            if cell.checker?.color == checkerColor {
                //находим координаты клеточек в которых может быть сделан ход (свободный) ВПЕРЕД
                let pointFreeCellRightS = CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8))
                let pointFreeCellLeftS = CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y + (checkerBoard.frame.height / 8))
                
                //находим координаты клеточек в которых может быть сделан ход (свободный) НАЗАД
                let pointFreeCellRightB = CGPoint(x: cell.position.x + (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8))
                let pointFreeCellLeftB = CGPoint(x: cell.position.x - (checkerBoard.frame.width / 8), y: cell.position.y - (checkerBoard.frame.height / 8))

                for possibleCell in arrayOfCells {
                    if possibleCell.position == pointFreeCellRightS {
                        if possibleCell.checker != nil && possibleCell.checker?.color != checkerColor {
                            let nextpoint = CGPoint(x: possibleCell.position.x + (checkerBoard.frame.width / 8), y: possibleCell.position.y + (checkerBoard.frame.height / 8))
                            for nextCell in arrayOfCells {
                                if nextCell.position == nextpoint && nextCell.checker == nil {
                                    arrayCellsWithCheckersToFight.append(cell)
                                }
                            }
                        }
                            break
                    }
                }
                
                for possibleCell in arrayOfCells {
                    if possibleCell.position == pointFreeCellLeftS {
                        if possibleCell.checker != nil && possibleCell.checker?.color != checkerColor {
                            let nextpoint = CGPoint(x: possibleCell.position.x - (checkerBoard.frame.width / 8), y: possibleCell.position.y + (checkerBoard.frame.height / 8))
                            for nextCell in arrayOfCells {
                                if nextCell.position == nextpoint && nextCell.checker == nil {
                                    arrayCellsWithCheckersToFight.append(cell)
                                }
                            }
                        }
                            break
                    }
                }
                
                for possibleCell in arrayOfCells {
                    if possibleCell.position == pointFreeCellRightB {
                        if possibleCell.checker != nil && possibleCell.checker?.color != checkerColor {
                            let nextpoint = CGPoint(x: possibleCell.position.x + (checkerBoard.frame.width / 8), y: possibleCell.position.y - (checkerBoard.frame.height / 8))
                            for nextCell in arrayOfCells {
                                if nextCell.position == nextpoint && nextCell.checker == nil {
                                    arrayCellsWithCheckersToFight.append(cell)
                                }
                            }
                        }
                            break
                    }
                }
                
                for possibleCell in arrayOfCells {
                    if possibleCell.position == pointFreeCellLeftB {
                        if possibleCell.checker != nil && possibleCell.checker?.color != checkerColor {
                            let nextpoint = CGPoint(x: possibleCell.position.x - (checkerBoard.frame.width / 8), y: possibleCell.position.y - (checkerBoard.frame.height / 8))
                            for nextCell in arrayOfCells {
                                if nextCell.position == nextpoint && nextCell.checker == nil {
                                    arrayCellsWithCheckersToFight.append(cell)
                                }
                            }
                        }
                            break
                    }
                }
            }
        }
        
        return arrayCellsWithCheckersToFight
        
    }
    
    //функция которая определяет клетки в которые можно ходить
    func possibleCellSteps(cell: UIView) -> [CGPoint] {
        
        var arrayOfPoints: [CGPoint] = []
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек ВПЕРЕД
        let pointFreeCellRightSWhiteChecker = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
        let pointFreeCellLeftSWhiteChecker = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек НАЗАД
        let pointFreeCellRightBWhiteChecker = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
        let pointFreeCellLeftBWhiteChecker = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))

        //находим координаты клеточек в котрые может быть сделан ударный ход для белых (вперед вправо, вперед влево, назад вправо, назад влево)
        let pointFightCellRightSWhiteChecker = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        let pointFightCellLeftSWhiteChecker = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        
        let pointFightCellRightBWhiteChecker = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        let pointFightCellLeftBWhiteChecker = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellRightSWhiteChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.white_checker.rawValue {
                    arrayOfPoints.append(pointFightCellRightSWhiteChecker)
                } else {
                    arrayOfPoints.append(pointFreeCellRightSWhiteChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellLeftSWhiteChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.white_checker.rawValue {
                    arrayOfPoints.append(pointFightCellLeftSWhiteChecker)
                } else {
                    arrayOfPoints.append(pointFreeCellLeftSWhiteChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellRightBWhiteChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.white_checker.rawValue {
                    arrayOfPoints.append(pointFightCellRightBWhiteChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellLeftBWhiteChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.white_checker.rawValue {
                    arrayOfPoints.append(pointFightCellLeftBWhiteChecker)
                }
            }
        }
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек ВПЕРЕД
        let pointFreeCellRightSBlackChecker = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
        let pointFreeCellLeftSBlackChecker = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
        
        //находим координаты клеточек в которых может быть сделан ход (свободный) для белых шашек НАЗАД
        let pointFreeCellRightBBlackChecker = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
        let pointFreeCellLeftBBlackChecker = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))

        //находим координаты клеточек в котрые может быть сделан ударный ход для белых (вперед вправо, вперед влево, назад вправо, назад влево)
        let pointFightCellRightSBlackChecker = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        let pointFightCellLeftSBlackChecker = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y - ((checkerBoard.frame.height / 8) * 2))
        
        let pointFightCellRightBBlackChecker = CGPoint(x: cell.frame.origin.x + ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        let pointFightCellLeftBBlackChecker = CGPoint(x: cell.frame.origin.x - ((checkerBoard.frame.width / 8) * 2), y: cell.frame.origin.y + ((checkerBoard.frame.height / 8) * 2))
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellRightSBlackChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.black_checker.rawValue {
                    arrayOfPoints.append(pointFightCellRightSBlackChecker)
                } else {
                    arrayOfPoints.append(pointFreeCellRightSBlackChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellLeftSBlackChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.black_checker.rawValue {
                    arrayOfPoints.append(pointFightCellLeftSBlackChecker)
                } else {
                    arrayOfPoints.append(pointFreeCellLeftSBlackChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellRightBBlackChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.black_checker.rawValue {
                    arrayOfPoints.append(pointFightCellRightBBlackChecker)
                }
            }
        }
        
        for cell in checkerBoard.subviews {
            if cell.frame.contains(pointFreeCellLeftBBlackChecker) {
                if !cell.subviews.isEmpty && cell.subviews.first?.tag != Checker_color.black_checker.rawValue {
                    arrayOfPoints.append(pointFightCellLeftBBlackChecker)
                }
            }
        }
        
        return arrayOfPoints
        
    }
    
}
