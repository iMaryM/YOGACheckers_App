//
//  PlayersViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 1.09.21.
//

import UIKit

class PlayersViewController: UIViewController {

    @IBOutlet weak var playersView: UIView!
    
    @IBOutlet weak var player1TextField: UITextField!
    @IBOutlet weak var player2TextField: UITextField!
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        decorationButton(button: playersView, color: #colorLiteral(red: 0.9423303008, green: 0.9125840068, blue: 0.9303908348, alpha: 1), borderWidth: 1.0, borderColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor, cornerRadius: 10.0, shadowColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor, shadowOffset: CGSize(width: 5.0, height: 5.0), shadowOpacity: 0.9)
        
    }
    
    @IBAction func returnMainMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToPlayersView(_ sender: Any) {
 
        guard let checkersViewController = getViewController(from: "Checkers", and: "CheckersViewController") as? CheckersViewController else { return }
        
        guard player1TextField.text != "" else {
            errorLabel1.text = "Input your name, please"
            errorLabel1.textColor = .red
            return
        }
        
        errorLabel1.text = ""
        
        guard player2TextField.text != "" else {
            errorLabel2.text = "Input your name, please"
            errorLabel2.textColor = .red
            return
        }

        errorLabel2.text = ""
        
        if Int.random(in: 0...1) == 0 {
            SettingsManager.shared.savedPlayerWhite = player1TextField.text
            SettingsManager.shared.savedPlayerBlack = player2TextField.text
        } else {
            SettingsManager.shared.savedPlayerWhite = player2TextField.text
            SettingsManager.shared.savedPlayerBlack = player1TextField.text
        }
        
        navigationController?.pushViewController(checkersViewController, animated: true)
        
    }
    
}
