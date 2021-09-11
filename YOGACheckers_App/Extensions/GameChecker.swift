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

        let arrayOfPoints = getPossibleCellSteps(cell: currentView, arryaOfFightCells: cellWhithCheckerNeedFight)

        switch sender.state {
        case .changed:
            checkerBoard.bringSubviewToFront(currentView) //передвигаем клеточку на передний план
            currentChecker.frame.origin = CGPoint(x: defaultOrigin.x + translation.x, y: defaultOrigin.y + translation.y) //передвигаем шашку относительно точки с которой сдвигаем
            sender.setTranslation(.zero, in: checkerBoard) //сбрасываем translation, чтобы всегда сдвиг был с нуля
        
        case .ended:
            var newCheckerView: UIView? = nil //клеточка в которую хотим поставить шашку
            var isFightChecker = false
            
            //проверяем является ли клетка в которую хотим поставить шашку черной
            for value in arrayOfCellsViews {
                //проверяем входит ли в текущее местоположение шашки клеточка доски
                if value.frame.contains(location) {
                    //проверяем входит ли клетка в допустимы дипазон для пермещения
                    if !arrayOfPoints.filter({$0.newCell == value.frame.origin}).isEmpty {
                        newCheckerView = value
                    }
                }
            }

            currentChecker.frame.origin = CGPoint(x: 5, y: 5) // сбрасываем позицию на 5;5 чтобы отцентрировать

            //проверяем есть ли в клеточке в которую хотим поставить шашку другая шашка
            guard let newCheckerView = newCheckerView, newCheckerView.subviews.isEmpty,
                  let checker = sender.view else {
                return }
            
            //опредяляем была ли побита шашка
            if !arrayOfPoints.filter({$0.fightCellPoint != nil}).isEmpty  {
                isFightChecker = true
            }
            
            if isFightChecker {
                for value in arrayOfPoints {
                        guard let fightCell = checkerBoard.subviews.filter({$0.frame.origin == value.fightCellPoint!}).first else { return }
                        fightCell.subviews.first?.removeFromSuperview()
                }
            }
            
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
    func getPossibleCellSteps(cell: UIView, arryaOfFightCells: [Cell]) -> [(fightCellPoint: CGPoint?, newCell: CGPoint)] {
        
        var arrayOfPoints: [(fightCellPoint: CGPoint?, newCell: CGPoint)] = []
        
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
        
        if arryaOfFightCells.filter({$0.position == cell.frame.origin}).isEmpty {
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellRight_SW) {
                    if currentCheckerToMove == Checker_color.white_checker {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_SW))
                    } else {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellRight_BW))
                    }
                }
            }
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellLeft_SW) {
                    if currentCheckerToMove == Checker_color.white_checker {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_SW))
                    } else {
                        arrayOfPoints.append((fightCellPoint: nil, newCell: pointFreeCellLeft_BW))
                    }
                }
            }
            
        } else {
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellRight_SW) {
                    if !cell.subviews.isEmpty {
                        if cell.subviews.first?.tag != currentCheckerToMove.rawValue {
                            let nextPoint = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
                            for nextCell in checkerBoard.subviews {
                                if nextCell.frame.origin == nextPoint && nextCell.subviews.first == nil {
                                    arrayOfPoints.append((fightCellPoint: pointFreeCellRight_SW, newCell: pointFightCellRight_SW))
                                }
                            }
                        }
                    }
                }
            }
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellLeft_SW) {
                    if !cell.subviews.isEmpty {
                        if cell.subviews.first?.tag != currentCheckerToMove.rawValue {
                            let nextPoint = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y + (checkerBoard.frame.height / 8))
                            for nextCell in checkerBoard.subviews {
                                if nextCell.frame.origin == nextPoint && nextCell.subviews.first == nil {
                                    arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_SW, newCell: pointFightCellLeft_SW))
                                }
                            }
                        }
                    }
                }
            }
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellRight_BW) {
                    if !cell.subviews.isEmpty {
                        if cell.subviews.first?.tag != currentCheckerToMove.rawValue {
                            let nextPoint = CGPoint(x: cell.frame.origin.x + (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
                            for nextCell in checkerBoard.subviews {
                                if nextCell.frame.origin == nextPoint && nextCell.subviews.first == nil {
                                    arrayOfPoints.append((fightCellPoint: pointFreeCellRight_BW, newCell: pointFightCellRight_BW))
                                }
                            }
                        }
                    }
                }
            }
            
            for cell in checkerBoard.subviews {
                if cell.frame.contains(pointFreeCellLeft_BW) {
                    if !cell.subviews.isEmpty {
                        if cell.subviews.first?.tag != currentCheckerToMove.rawValue {
                            let nextPoint = CGPoint(x: cell.frame.origin.x - (checkerBoard.frame.width / 8), y: cell.frame.origin.y - (checkerBoard.frame.height / 8))
                            for nextCell in checkerBoard.subviews {
                                if nextCell.frame.origin == nextPoint && nextCell.subviews.first == nil {
                                    arrayOfPoints.append((fightCellPoint: pointFreeCellLeft_BW, newCell: pointFightCellLeft_BW))
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return arrayOfPoints
        
    }
    
}
