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
              ((currentChecker.tag == 0 || currentChecker.tag == 2) && currentCheckerToMove == .white_checker)  || ((currentChecker.tag == 1 || currentChecker.tag == 3) && currentCheckerToMove == .black_checker) else {return}
                
        let location = sender.location(in: checkerBoard)
        
        let translation = sender.translation(in: checkerBoard)
        
        guard let currentView = sender.view?.superview, //определяем клеточку на которой стоит шашка
              let currentChecker = sender.view, //определяем шашку которую двигаем
              let defaultOrigin = sender.view?.frame.origin else { //определяем координаты шашки которую будем двигать
                  return
              }

            //проверяем есть ли шашки которые должны обязательно побить
            let cellWhithCheckerNeedFight = getCellWithCheckerNeedToFight()
            
            //получаем массив возможных ходов для шашки, которую мы взяли
            var arrayOfPoints = getPossibleCellSteps(cell: currentView, arryaOfFightCells: cellWhithCheckerNeedFight)
            
            if let currentViewMustFight = currentViewMustFight {
                //если есть шашки которые должны бить проверяем шашка которую мы взяли входит в массив шашек, которые должны бить
                if !cellWhithCheckerNeedFight.isEmpty {
                    guard !cellWhithCheckerNeedFight.filter({$0.position == currentView.frame.origin}).isEmpty else { return }
                }
                //получаем массив возможных ходов для шашки, которую мы взяли
                arrayOfPoints = getPossibleCellSteps(cell: currentViewMustFight, arryaOfFightCells: cellWhithCheckerNeedFight)
            } else {
                //если есть шашки которые должны бить проверяем шашка которую мы взяли входит в массив шашек, которые должны бить
                if !cellWhithCheckerNeedFight.isEmpty {
                    guard !cellWhithCheckerNeedFight.filter({$0.position == currentView.frame.origin}).isEmpty else { return }
                }
                //получаем массив возможных ходов для шашки, которую мы взяли
                arrayOfPoints = getPossibleCellSteps(cell: currentView, arryaOfFightCells: cellWhithCheckerNeedFight)
            }
            
            switch sender.state {
            case .changed:
                checkerBoard.bringSubviewToFront(currentView) //передвигаем клеточку на передний план
                currentChecker.frame.origin = CGPoint(x: defaultOrigin.x + translation.x, y: defaultOrigin.y + translation.y) //передвигаем шашку относительно точки с которой сдвигаем
                sender.setTranslation(.zero, in: checkerBoard) //сбрасываем translation, чтобы всегда сдвиг был с нуля
                
            case .ended:
                var newCheckerView: UIView? = nil //клеточка в которую хотим поставить шашку
                var isFightChecker = false
                
                //проверяем входит ли область в которую двегием шашку в клеточку доски
                for cell in checkerBoard.subviews {
                    if cell.frame.contains(location) {
                        //проверяем входит ли клеточка в допустимый диапазон для перемещения
                        if !arrayOfPoints.filter({$0.newCell == cell.frame.origin}).isEmpty {
                            newCheckerView = cell
                        }
                    }
                }
                
                currentChecker.frame.origin = CGPoint(x: 5, y: 5) // сбрасываем позицию на 5;5 чтобы отцентрировать
                
                //проверяем есть ли в клеточке в которую хотим поставить шашку другая шашка
                guard let newCheckerView = newCheckerView, newCheckerView.subviews.isEmpty,
                      let checker = sender.view else {
                          return }
                
                //определяем клетку в которой была побита шашка
                let fightedCells = arrayOfPoints.filter({$0.newCell == newCheckerView.frame.origin && $0.fightCellPoint != nil})
                
                //опредяляем была ли побита шашка
                if !fightedCells.isEmpty {
                    isFightChecker = true
                }
                
                //определяем шашку, которую побили и убираем ее с поля
                if isFightChecker {
                    for fightedCell in fightedCells {
                        guard let fightCellOnCheckerBoard = checkerBoard.subviews.filter({$0.frame.origin == fightedCell.fightCellPoint}).first else { return }
                        fightCellOnCheckerBoard.subviews.first?.removeFromSuperview()
                    }
                }
                
                newCheckerView.addSubview(checker) // добавляем шашку на новую клетку
                
                UIView.animate(withDuration: 0.3) {
                    checker.transform = .identity
                }
                
                //проверяем стала ли шашка на клетку превращения в дамку
                if newCheckerView.frame.origin.y == 0.0, checker.tag == Checker_color.black_checker.rawValue {
                    for cell in checkerBoard.subviews.filter({$0.frame.origin == newCheckerView.frame.origin}) {
                        guard let checker = cell.subviews.first as? UIImageView else {return}
                        checker.tag = Checker_color.black_queen_checker.rawValue
                        
                        UIView.animate(withDuration: 0.5) {
                            checker.image = UIImage(named: (SettingsManager.shared.savedBlackCheckerQueen)!)
                        }
                        
                    }
                }
                
                if newCheckerView.frame.origin.y == (newCheckerView.frame.height * 7), checker.tag == Checker_color.white_checker.rawValue {
                    for cell in checkerBoard.subviews.filter({$0.frame.origin == newCheckerView.frame.origin}) {
                        guard let checker = cell.subviews.first as? UIImageView else {return}
                        checker.tag = Checker_color.white_queen_checker.rawValue
                        
                        UIView.animate(withDuration: 0.5) {
                            checker.image = UIImage(named: (SettingsManager.shared.savedWhiteCheckerQueen)!)
                        }
                        
                    }
                }
                
                if getWinnerColor() != nil {
                    
                    let time = calculateTime(seconds: SettingsManager.shared.savedTimer)
                    
                    //добавляем запись в таблицу
                    let result_m = Results_m(
                        player_1: SettingsManager.shared.savedPlayerWhite,
                        checker_image_player_1: SettingsManager.shared.savedWhiteChecker,
                        player_2: SettingsManager.shared.savedPlayerBlack,
                        checker_image_player_2: SettingsManager.shared.savedBlackChecker,
                        winner: getWinnerColor() == .white_checker ? SettingsManager.shared.savedPlayerWhite : SettingsManager.shared.savedPlayerBlack,
                        date_of_win: SettingsManager.shared.savedDate,
                        duration: convertToTimeString(hours: time.0, minutes: time.1, seconds: time.2))
                    
                    CoreDataManager.shared.addResult(result_m: result_m)
                    
                    self.timer.invalidate()
                    
                    presentAlertController(with: "Congratilution!", message: getWinnerColor() == .white_checker ? "Player \(SettingsManager.shared.savedPlayerWhite!) WIN!" : "Player \(SettingsManager.shared.savedPlayerBlack!) WIN!", actionButtons: UIAlertAction(title: "Exit game", style: .cancel, handler: { _ in
                        //удаляем файл с игрой
                        self.deleteFile()
                        
                        //удаление данных про сохраненный таймер
                        UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.seconds.rawValue)
                        //удаление данных про цвет шашки которая должна ходить
                        UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.movedChecker.rawValue)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        self.timer.invalidate()
                    }))
                    
                } else {
                    
                    //проверяем есть ли шашки которые должны обязательно побить
                    let cellWhithCheckerNeedFight = getCellWithCheckerNeedToFight()
                    
                    //если есть шашки которые должны бить проверяем шашка которую мы взяли входит в массив шашек, которые должны бить
                    if !cellWhithCheckerNeedFight.isEmpty, isFightChecker {
                        guard !cellWhithCheckerNeedFight.filter({$0.position == newCheckerView.frame.origin}).isEmpty else {
                            currentViewMustFight = nil
                            getColorForCurrentChecker ()
                            return
                        }
                        //фиксируем шашку, которая должна побить
                        currentViewMustFight = newCheckerView
                    } else {
                        currentViewMustFight = nil
                        getColorForCurrentChecker ()
                    }
                }
                
            default:
                break
            }
    }
    
    //функция для определения цвета который должен ходить
    func getColorForCurrentChecker () {
        
        currentCheckerToMove = currentCheckerToMove == .white_checker ? .black_checker : .white_checker
        
        if currentCheckerToMove == .white_checker {
            labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerWhite!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedWhiteChecker!)
        } else {
            labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerBlack!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedBlackChecker!)
        }
    }

    //функция для определения победителя
    func getWinnerColor() -> Checker_color? {
        var winnerColor: Checker_color? = nil
        let arrayOfCheckerCells = createArryaOfCells()
        
        let arrayOfWhiteCheckers = arrayOfCheckerCells.filter({$0.checker?.color == .white_checker})
        let arrayOfBlachCheckers = arrayOfCheckerCells.filter({$0.checker?.color == .black_checker})
        
        if arrayOfWhiteCheckers.count == 0 {
            winnerColor = .black_checker
        }
        
        if arrayOfBlachCheckers.count == 0 {
            winnerColor = .white_checker
        }
        
        return winnerColor
    }
    
}
