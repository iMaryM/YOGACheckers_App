//
//  ViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 26.07.21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var buttonViewStartGame: CustomButtonMainMenu!
    @IBOutlet weak var buttonViewResults: CustomButtonMainMenu!
    @IBOutlet weak var buttonViewSettings: CustomButtonMainMenu!
    
    @IBOutlet weak var buttonHistory: CustomButtonMainMenu!
    
    var isNewGame = true
    
    var textFieldPlayer1 = UITextField()
    var textFieldPlayer2 = UITextField()
    
    var blurEffectView = UIVisualEffectView()
    var playersView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.value(forKey: KeyesUserDefaults.whiteCheckerImage.rawValue) == nil {
            UserDefaults.standard.setValue("Checker_white_1", forKey: KeyesUserDefaults.whiteCheckerImage.rawValue)
        }
        
        if UserDefaults.standard.value(forKey: KeyesUserDefaults.whiteCheckerQueenImage.rawValue) == nil {
            UserDefaults.standard.setValue("Checker_white_1_queen_1", forKey: KeyesUserDefaults.whiteCheckerQueenImage.rawValue)
        }
        
        if UserDefaults.standard.value(forKey: KeyesUserDefaults.blackCheckerImage.rawValue) == nil {
            UserDefaults.standard.setValue("Checker_black_1", forKey: KeyesUserDefaults.blackCheckerImage.rawValue)
        }
        
        if UserDefaults.standard.value(forKey: KeyesUserDefaults.blackCheckerQueenImage.rawValue) == nil {
            UserDefaults.standard.setValue("Checker_black_1_queen_1", forKey: KeyesUserDefaults.blackCheckerQueenImage.rawValue)
        }
        
        buttonViewStartGame.buttonDidTap = {
            guard let checkersViewController = self.getViewController(from: "Checkers", and: "CheckersViewController") as? CheckersViewController,
                  let playersViewController = self.getViewController(from: "Players", and: "PlayersViewController") as? PlayersViewController  else { return }

            //проверяем есть ли файс с сохраненной игрой
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("savedGame")
            
            //если файл есть то отображаем алерт
            if FileManager().fileExists(atPath: fileURL.path) {
                self.presentAlertController(with: nil, message: "Do you want to load saved game or start new game?", preferredStyle: .alert, actionButtons: UIAlertAction(title: "Saved game", style: .default, handler: { _ in
                    
                    checkersViewController.isNewGame = false
                    self.navigationController?.pushViewController(checkersViewController, animated: true)
                    
                }), UIAlertAction(title: "New game", style: .default, handler: { _ in
                    
                    checkersViewController.isNewGame = true
                    self.navigationController?.pushViewController(playersViewController, animated: true)
                    
                }))
            } else {
                //если файла нет, то переходим на вью с шашками
                checkersViewController.isNewGame = true
                self.navigationController?.pushViewController(playersViewController, animated: true)
            }
        }
        
        buttonViewResults.buttonDidTap = {
            guard let resultsViewController = self.getViewController(from: "Results", and: "ResultsViewController") as? ResultsViewController  else { return }
            self.navigationController?.pushViewController(resultsViewController, animated: true)
        }
        
        buttonViewSettings.buttonDidTap = {
            guard let settingsViewController = self.getViewController(from: "Settings", and: "SettingsViewController") as? SettingsViewController  else { return }
            self.navigationController?.pushViewController(settingsViewController, animated: true)
        }

        buttonHistory.buttonDidTap = {
            guard let historyViewController = self.getViewController(from: "History", and: "HistoryViewController") as? HistoryViewController  else { return }
            self.navigationController?.pushViewController(historyViewController, animated: true)
        }
    }
    
}

