//
//  HistoryViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 8.08.21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
