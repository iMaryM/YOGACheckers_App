//
//  LanguageViewController.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 9.10.21.
//

import UIKit
import AVFoundation

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var languageTableView: UITableView!
    
    var languages: [String] = ["English", "Русский", "Українська"]
    var musicPlayer: AVPlayer?
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setTitle("button_back".localized(by: language), for: .normal)
        
        setupTable()
    }
    
    func setupTable() {
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageTableViewCell")
    }
    
    @IBAction func goToBackController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell") as? LanguageTableViewCell else {return UITableViewCell()}
        
        if SettingsManager.shared.userLanguage == nil {
            switch SettingsManager.shared.localLanguage {
            case "en":
                if indexPath.row == 0 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            case "ru":
                if indexPath.row == 1 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            case "uk":
                if indexPath.row == 2 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            default: break
            }
        } else {
            switch SettingsManager.shared.userLanguage {
            case "en":
                if indexPath.row == 0 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            case "ru":
                if indexPath.row == 1 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            case "uk":
                if indexPath.row == 2 {
                    cell.setup(language: languages[indexPath.row], isChecked: false)
                } else {
                    cell.setup(language: languages[indexPath.row], isChecked: true)
                }
            default: break
            }
        }
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            SettingsManager.shared.userLanguage = "en"
        }
        
        if indexPath.row == 1 {
            SettingsManager.shared.userLanguage = "ru"
        }
        
        if indexPath.row == 2 {
            SettingsManager.shared.userLanguage = "uk"
        }
        
        tableView.reloadData()
    }
    
}
