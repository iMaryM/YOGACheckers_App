//
//  CheckersViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 26.07.21.
//

import UIKit

class CheckersViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurNavigationBar: UIVisualEffectView!
    @IBOutlet weak var currentCheckerToMoveImageView: UIImageView!

    @IBOutlet weak var labelPlayer: UILabel!
    
    var checkerBoard = UIView()
    
    var cell: Cell = Cell()
    var arrayOfCells: [Cell] = []
    var cellsWithChecker: [Cell] = []
    
    var arrayOfCellsViews = [UIImageView]()
    
    var checker = Checker()
    var arrayOfCheckers: [Checker] = []
    
    var arrayOfCheckersView = [UIImageView]()
    
    var timerLabel = UILabel()
    var timer: Timer = Timer()
    var second: Int = 0
    
    var dateLabel = UILabel()
    var dateString = ""
    
    var currentCheckerToMove: Checker_color = .white_checker
    
    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let screenSize = UIScreen.main.bounds

    //флаг для определения новая игра или сохраненная
    var isNewGame: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if isNewGame {
            //удаление файла с сохраненной игрой
            deleteFile()
            
            //удаление данных про сохраненный таймер
            UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.seconds.rawValue)
            
            //устанавливаем цвет шашки, которая должна ходить
            SettingsManager.shared.savedColorOfCheckerShouldBeMoved = currentCheckerToMove.rawValue

            //устанавливаем дату
            SettingsManager.shared.savedDate = Date().getCurrentDate(from: "dd MMMM yyyy")
            
            //отрисовка новой доски
            drawNewCheckerBoard()

        } else {
            drawSavedCheckerBoard(screenSize: screenSize)
        }
        
        dateString = SettingsManager.shared.savedDate!
        
        drawTimer(screenSize: screenSize, timerLabel: &timerLabel)
        
        second = SettingsManager.shared.savedTimer
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)

        guard let image = SettingsManager.shared.savedBackgroungOfCheckersView as? UIImage else {
            return
        }
        
        if SettingsManager.shared.savedColorOfCheckerShouldBeMoved == Checker_color.white_checker.rawValue {
            labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerWhite!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedWhiteChecker!)
        } else {
            labelPlayer.text = "Move: \(SettingsManager.shared.savedPlayerBlack!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedBlackChecker!)
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        timer.invalidate()
        presentAlertController(with: nil, message: "Do you want to save the game?", actionButtons: UIAlertAction(title: "Save", style: .default, handler: { _ in
            
            //записываем время таймера (секунды) в UserDefaults
            SettingsManager.shared.savedTimer = self.second
            //записываем дату партии
            SettingsManager.shared.savedDate = self.dateString
            //записываем цвет шашки которая должна ходить в UserDefaults
            SettingsManager.shared.savedColorOfCheckerShouldBeMoved = self.currentCheckerToMove.rawValue
            
            //сохраняем массив клеточек
            self.arrayOfCells = self.createArryaOfCells()
            
            //обнуляем массив (чтобы записывалось заново, а не дописывалось новое)
            self.cellsWithChecker.removeAll()
            
            //находим клеточки с шашками и записываем их в массив
            for cell in self.arrayOfCells {
                if cell.checker != nil {
                    self.cellsWithChecker.append(cell)
                }
            }
            
            //сохраняем в файл массив клеточек с шашками
            SettingsManager.shared.savedCellsWithCheckers = self.cellsWithChecker
            
            self.navigationController?.popToRootViewController(animated: true)
            self.timer.invalidate()
        }), UIAlertAction(title: "Don't save", style: .destructive, handler: { _ in
        
            //удаляем файл с игрой
            self.deleteFile()
            
            //удаление данных про сохраненный таймер
            UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.seconds.rawValue)
            //удаление данных про цвет шашки которая должна ходить
            UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.movedChecker.rawValue)
            
            self.navigationController?.popToRootViewController(animated: true)
            self.timer.invalidate()
        }))
        
    }
    
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
    
    @objc
    func timerCounter () {
        second += 1
        let time = calculateTime(seconds: second)
        let timeString = convertToTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        timerLabel.attributedText = addAtributedTextForTimer(for: timeString)
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
    
    
    
    func drawNewCheckerBoard() {
        
        //отрисовка доски
        drawCheckerboard()
        
        drawCell()
        
        drawChecker()
        
        for value in arrayOfCheckersView {
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            tapGesture.minimumPressDuration = 0.1
            tapGesture.delegate = self
            value.addGestureRecognizer(tapGesture)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
            value.addGestureRecognizer(panGesture)
        }
        
    }
    
    func drawSavedCheckerBoard(screenSize: CGRect) {

        //забираем данные из файла
        self.cellsWithChecker = SettingsManager.shared.savedCellsWithCheckers

        //отрисовка доски
        drawCheckerboard()
        
        drawCell()
        
        drawCheckerFromFile()
        
        for value in arrayOfCheckersView {
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            tapGesture.minimumPressDuration = 0.1
            tapGesture.delegate = self
            value.addGestureRecognizer(tapGesture)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
            value.addGestureRecognizer(panGesture)
        }

    }
    
    func createArryaOfCells() -> [Cell] {
        
        var newCell = Cell()
        var arrayOfCells: [Cell] = []
        
        for cell in checkerBoard.subviews {
            
            newCell = cell.tag == Cell_color.white_cell.rawValue ? Cell(position: cell.frame.origin, imageName: "light_3", color: Cell_color.white_cell.rawValue) : Cell(position: cell.frame.origin, imageName: "dark_3", color: Cell_color.black_cell.rawValue)
            
            if !cell.subviews.isEmpty {

                guard let color = cell.subviews.first?.tag else {
                    return []
                }
                if color == Checker_color.white_checker.rawValue {
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedWhiteChecker)!, color: color))
                } else {
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedBlackChecker)!, color: color))
                }
                
            }
            
            arrayOfCells.append(newCell)
        }
        
        return arrayOfCells
    }
    
    func deleteFile() {
        //удаление файла игрой
        let fileURL = documentDirectoryURL.appendingPathComponent("savedGame")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
}

extension CheckersViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
