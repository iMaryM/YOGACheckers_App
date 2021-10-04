//
//  CustomMusicViewController.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 4.10.21.
//

import UIKit
import AVFoundation

class CustomMusicViewController: UIViewController {

    @IBOutlet weak var musicTableView: UITableView!
    
    var musicPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTable()
        
    }
    
    func setUpTable() {
        musicTableView.delegate = self
        musicTableView.dataSource = self
        musicTableView.register(UINib(nibName: "OnOffMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "OnOffMusicTableViewCell")
    }
    
    @IBAction func goToSettings(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension CustomMusicViewController: UITableViewDelegate {
    
}

extension CustomMusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OnOffMusicTableViewCell") as? OnOffMusicTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setUpCell(player: musicPlayer)
        return cell
    }
    
}
