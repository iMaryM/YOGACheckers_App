//
//  ResultsViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 31.07.21.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func goToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
