//
//  ResultsViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 31.07.21.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var clearAllButton: UIButton!
    
    var language: String = ""
    var results: [Results_m] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        results = CoreDataManager.shared.getResults()
        
        setupTable()
        
        clearAllButton.setTitle("button_clear_all".localized(by: language), for: .normal)
        backButton.setTitle("back_to_menu_button".localized(by: language), for: .normal)
    }
    
    private func setupTable() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView()
        resultTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
    }

    @IBAction func goToMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func claerAll(_ sender: Any) {
        presentAlertController(with: "alert_delete_results_title".localized(by: language), message: "alert_delete_results_message".localized(by: language), preferredStyle: .alert, isUsedTextField: false, actionButtons: UIAlertAction(title: "alert_clear_button".localized(by: language), style: .destructive, handler: { _ in
            CoreDataManager.shared.deleteResults()
            self.results.removeAll()
            self.resultTableView.reloadData()
        }), UIAlertAction(title: "alert_don't_clear_button".localized(by: language), style: .cancel, handler: { _ in
        }))
    }
    
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell") as? ResultTableViewCell else {return UITableViewCell()}
        cell.setupCell(result_m: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
