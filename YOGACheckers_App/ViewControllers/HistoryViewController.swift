//
//  HistoryViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 8.08.21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    var language: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("back_to_menu_button".localized(by: language), for: .normal)
        
    }

    @IBAction func backToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
