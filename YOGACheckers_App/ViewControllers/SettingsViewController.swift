//
//  SettingsViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 31.07.21.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var musicPlayer: AVPlayer?
    
    var settings: [String] = []
    
    var language: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settings = ["custom_checker".localized(by: language), "custom_background".localized(by: language), "custom_music".localized(by: language), "custom_language".localized(by: language)]
        
        backButton.setTitle("back_to_menu_button".localized(by: language), for: .normal)
        setupTable()
        
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    @IBAction func goToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settings.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupSetting(setting: settings[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            guard let customCheckersViewController = getViewController(from: "CustomChecker", and: "CustomCheckerViewController") as? CustomCheckerViewController else { return }
            customCheckersViewController.language = language
            navigationController?.pushViewController(customCheckersViewController, animated: true)
        }
        
        if indexPath.row == 1 {
            guard let customBackgroundViewController = getViewController(from: "CustomBackground", and: "CustomBackgroundViewController") as? CustomBackgroundViewController else { return }
            customBackgroundViewController.language = language
            navigationController?.pushViewController(customBackgroundViewController, animated: true)
        }
        
        if indexPath.row == 2 {
            guard let customMusicViewController = getViewController(from: "CustomMusic", and: "CustomMusicViewController") as? CustomMusicViewController else { return }
            customMusicViewController.musicPlayer = musicPlayer
            customMusicViewController.language = language
            navigationController?.pushViewController(customMusicViewController, animated: true)
        }
        
        if indexPath.row == 3 {
            guard let languageViewController = getViewController(from: "Language", and: "LanguageViewController") as? LanguageViewController else { return }
            languageViewController.musicPlayer = musicPlayer
            languageViewController.language = language
            navigationController?.pushViewController(languageViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
