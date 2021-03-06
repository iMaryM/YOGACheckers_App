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
    @IBOutlet weak var backButton: UIButton!
    
    var checkerBoard = UIView()
    
    var cell: Cell = Cell()
    var arrayOfCells: [Cell] = []
    
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
    
    var language = ""

    var currentViewMustFight: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backButton.setTitle("back_to_menu_button".localized(by: language), for: .normal)
        
        if isNewGame {
            //удаление файла с сохраненной игрой
            deleteFile()
            
            //удаление данных про сохраненный таймер
            UserDefaults.standard.removeObject(forKey: KeyesUserDefaults.seconds.rawValue)
            
            //устанавливаем цвет шашки, которая должна ходить
            SettingsManager.shared.savedColorOfCheckerShouldBeMoved = currentCheckerToMove.rawValue

            //устанавливаем дату
            SettingsManager.shared.savedDate = Date().getCurrentDate(from: "dd MMMM yyyy", locale: Locale(identifier: language))
            
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
            labelPlayer.text = "\(SettingsManager.shared.savedPlayerWhite!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedWhiteChecker!)
        } else {
            labelPlayer.text = "\(SettingsManager.shared.savedPlayerBlack!)"
            currentCheckerToMoveImageView.image = UIImage(named: SettingsManager.shared.savedBlackChecker!)
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        timer.invalidate()
        presentAlertController(with: nil, message: "allert_message_save_game".localized(by: language), actionButtons: UIAlertAction(title: "allert_button_save_game".localized(by: language), style: .default, handler: { _ in
            
            //записываем время таймера (секунды) в UserDefaults
            SettingsManager.shared.savedTimer = self.second
            //записываем дату партии
            SettingsManager.shared.savedDate = self.dateString
            //записываем цвет шашки которая должна ходить в UserDefaults
            SettingsManager.shared.savedColorOfCheckerShouldBeMoved = self.currentCheckerToMove.rawValue
            
            //сохраняем массив клеточек
            self.arrayOfCells = self.createArryaOfCells()
            
            //сохраняем в файл массив клеточек с шашками
            SettingsManager.shared.savedCells = self.arrayOfCells
            
            self.navigationController?.popToRootViewController(animated: true)
            self.timer.invalidate()
        }), UIAlertAction(title: "allert_button_don't_save_game".localized(by: language), style: .destructive, handler: { _ in
        
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
        self.arrayOfCells = SettingsManager.shared.savedCells

        //отрисовка доски
        drawCheckerboard()
        
        drawCheckerboardFromFile()
        
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
                
                guard let checker = cell.subviews.first else {
                    return []
                }
                
                switch checker.tag {
                case Checker_color.white_checker.rawValue:
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedWhiteChecker)!, color: checker.tag, isQueen: false))
                case Checker_color.white_queen_checker.rawValue:
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedWhiteCheckerQueen)!, color: checker.tag, isQueen: true))
                case Checker_color.black_checker.rawValue:
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedBlackChecker)!, color: checker.tag, isQueen: false))
                case Checker_color.black_queen_checker.rawValue:
                    newCell.addChecker(checker: Checker(imageName: (SettingsManager.shared.savedBlackCheckerQueen)!, color: checker.tag, isQueen: true))
                    
                default:
                    break
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
