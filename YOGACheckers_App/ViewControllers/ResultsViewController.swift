//
//  ResultsViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 31.07.21.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    var language: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setTitle("back_to_menu_button".localized(by: language), for: .normal)
    }

    @IBAction func goToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
