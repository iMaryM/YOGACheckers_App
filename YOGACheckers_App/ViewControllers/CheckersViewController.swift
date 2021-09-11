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
