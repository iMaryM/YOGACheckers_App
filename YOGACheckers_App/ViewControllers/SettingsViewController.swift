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
    
    var musicPlayer: AVPlayer?
    
    var settings: [String] = ["Custom checker", "Custom backgroung", "Custom Music"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Custom Settings"
    }
    
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
            navigationController?.pushViewController(customCheckersViewController, animated: true)
        }
        
        if indexPath.row == 1 {
            guard let customBackgroundViewController = getViewController(from: "CustomBackground", and: "CustomBackgroundViewController") as? CustomBackgroundViewController else { return }
            navigationController?.pushViewController(customBackgroundViewController, animated: true)
        }
        
        if indexPath.row == 2 {
            guard let customMusicViewController = getViewController(from: "CustomMusic", and: "CustomMusicViewController") as? CustomMusicViewController else { return }
            customMusicViewController.musicPlayer = musicPlayer
            navigationController?.pushViewController(customMusicViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
