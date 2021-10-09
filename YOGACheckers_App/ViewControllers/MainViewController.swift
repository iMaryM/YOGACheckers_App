//
//  ViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 26.07.21.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet weak var buttonViewStartGame: CustomButtonMainMenu!
    @IBOutlet weak var buttonViewResults: CustomButtonMainMenu!
    @IBOutlet weak var buttonViewSettings: CustomButtonMainMenu!
    
    @IBOutlet weak var buttonHistory: CustomButtonMainMenu!
    @IBOutlet weak var buttonRules: CustomButtonMainMenu!
    @IBOutlet weak var buttonAbout: CustomButtonMainMenu!
    
    var isNewGame = true
    
    var textFieldPlayer1 = UITextField()
    var textFieldPlayer2 = UITextField()
    
    var blurEffectView = UIVisualEffectView()
    var playersView = UIView()
    
    var playerMusic: AVPlayer?
    var language: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFromFile()
        
        setMusic()
        
        if SettingsManager.shared.musicOnOff == 0 {
            playerMusic?.play()
            playerMusic?.volume = 0.1
        }
        
        buttonViewStartGame.buttonDidTap = {
            guard let checkersViewController = self.getViewController(from: "Checkers", and: "CheckersViewController") as? CheckersViewController,
                  let playersViewController = self.getViewController(from: "Players", and: "PlayersViewController") as? PlayersViewController  else { return }

            playersViewController.language = self.language
            checkersViewController.language = self.language
            
            //проверяем есть ли файс с сохраненной игрой
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentDirectoryURL.appendingPathComponent("savedGame")
            
            //если файл есть то отображаем алерт
            if FileManager().fileExists(atPath: fileURL.path) {
                self.presentAlertController(with: nil, message: "allert_message_load_saved_game".localized(by: self.language), preferredStyle: .alert, actionButtons: UIAlertAction(title: "allert_button_saved_game".localized(by: self.language), style: .default, handler: { _ in
                    
                    checkersViewController.isNewGame = false
                    self.navigationController?.pushViewController(checkersViewController, animated: true)
                    
                }), UIAlertAction(title: "allert_button_new_game".localized(by: self.language), style: .default, handler: { _ in
                    
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
            resultsViewController.language = self.language
            self.navigationController?.pushViewController(resultsViewController, animated: true)
        }
        
        buttonViewSettings.buttonDidTap = {
            guard let settingsViewController = self.getViewController(from: "Settings", and: "SettingsViewController") as? SettingsViewController  else { return }
            settingsViewController.language = self.language
            settingsViewController.musicPlayer = self.playerMusic
            self.navigationController?.pushViewController(settingsViewController, animated: true)
        }

        buttonHistory.buttonDidTap = {
            guard let historyViewController = self.getViewController(from: "History", and: "HistoryViewController") as? HistoryViewController  else { return }
            historyViewController.language = self.language
            self.navigationController?.pushViewController(historyViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        localized()
    }
    
    func setupFromFile() {
        
        if SettingsManager.shared.userLanguage == nil {
            guard let localeLanguage = NSLocale.preferredLanguages.first else {return}
            SettingsManager.shared.localLanguage = localeLanguage
        }
        
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
    }
    
    func setMusic() {
        guard let pathMusic = Bundle.main.path(forResource: "Hans_Zimmer_Rain", ofType: "mp3") else {return}
        
        let URLMusic = URL(fileURLWithPath: pathMusic)
        
        let asset = AVAsset(url: URLMusic)
        let playerItem = AVPlayerItem(asset: asset)
        playerMusic = AVPlayer(playerItem: playerItem)
    }
    
    func localized() {
        language = SettingsManager.shared.userLanguage == nil ? (SettingsManager.shared.localLanguage ?? "") : (SettingsManager.shared.userLanguage ?? "")
        
        buttonViewStartGame.text = "button_start_game".localized(by: language)
        buttonViewResults.text = "button_results".localized(by: language)
        buttonViewSettings.text = "button_settings".localized(by: language)
        buttonHistory.text = "button_history".localized(by: language)
        buttonRules.text = "button_rules".localized(by: language)
        buttonAbout.text = "button_about".localized(by: language)
    }
    
}

