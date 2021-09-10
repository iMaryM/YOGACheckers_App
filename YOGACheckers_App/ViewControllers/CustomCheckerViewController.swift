//
//  CustomCheckerViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

class CustomCheckerViewController: UIViewController {

    @IBOutlet weak var whiteCheckersCollectionView: UICollectionView!
    @IBOutlet weak var whiteCheckersQueenContollerView: UICollectionView!
    @IBOutlet weak var blackCheckersCollectionView: UICollectionView!
    @IBOutlet weak var blackCheckersQueenContollerView: UICollectionView!
    
    var whiteCheckersImageName = ["Checker_white_1", "Checker_white_2", "Checker_white_3", "Checker_white_4", "Checker_white_5", "Checker_white_6"]
    var whiteCheckersQueenImageName = ["Checker_white_1_queen_1", "Checker_white_1_queen_2", "Checker_white_1_queen_3",
                                       "Checker_white_2_queen_1", "Checker_white_2_queen_2", "Checker_white_2_queen_3",
                                       "Checker_white_3_queen_1", "Checker_white_3_queen_2", "Checker_white_3_queen_3",
                                       "Checker_white_4_queen_1", "Checker_white_4_queen_2", "Checker_white_4_queen_3",
                                       "Checker_white_5_queen_1", "Checker_white_5_queen_2", "Checker_white_5_queen_3",
                                       "Checker_white_6_queen_1", "Checker_white_6_queen_2", "Checker_white_6_queen_3"]
    var blackCheckersImageName = ["Checker_black_1", "Checker_black_2", "Checker_black_3", "Checker_black_4", "Checker_black_5", "Checker_black_6"]
    var blackCheckersQueenImageName = ["Checker_black_1_queen_1", "Checker_black_1_queen_2", "Checker_black_1_queen_3",
                                       "Checker_black_2_queen_1", "Checker_black_2_queen_2", "Checker_black_2_queen_3",
                                       "Checker_black_3_queen_1", "Checker_black_3_queen_2", "Checker_black_3_queen_3",
                                       "Checker_black_4_queen_1", "Checker_black_4_queen_2", "Checker_black_4_queen_3",
                                       "Checker_black_5_queen_1", "Checker_black_5_queen_2", "Checker_black_5_queen_3",
                                       "Checker_black_6_queen_1", "Checker_black_6_queen_2", "Checker_black_6_queen_3"]
    
    var whiteQueens: [String] = []
    var blackQueens: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWhiteCheckersCollectionView(collectionView: whiteCheckersCollectionView)
        setupWhiteCheckersCollectionView(collectionView: whiteCheckersQueenContollerView)
        setupWhiteCheckersCollectionView(collectionView: blackCheckersCollectionView)
        setupWhiteCheckersCollectionView(collectionView: blackCheckersQueenContollerView)

    }
    
    private func setupWhiteCheckersCollectionView(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CheckerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CheckerCollectionViewCell")
    }
    
    
    @IBAction func goToPreViewController(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension CustomCheckerViewController: UICollectionViewDelegate {

}

extension CustomCheckerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == whiteCheckersCollectionView {
            return whiteCheckersImageName.count
        }
        
        if collectionView == whiteCheckersQueenContollerView  {
            
            guard let string = SettingsManager.shared.savedWhiteChecker else {return 0}
            
            whiteQueens.removeAll()
            
            for value in whiteCheckersQueenImageName {
                if value == "\(String(describing: string))_queen_1" || value == "\(String(describing: string))_queen_2"  || value == "\(String(describing: string))_queen_3" {
                    whiteQueens.append(value)
                }
            }
            
            return whiteQueens.count
        }
        
        if collectionView == blackCheckersCollectionView {
            return blackCheckersImageName.count
        }
        
        if collectionView == blackCheckersQueenContollerView  {
            
            guard let string = SettingsManager.shared.savedBlackChecker else {return 0}
            
            blackQueens.removeAll()
            
            for value in blackCheckersQueenImageName {
                if value == "\(String(describing: string))_queen_1" || value == "\(String(describing: string))_queen_2"  || value == "\(String(describing: string))_queen_3" {
                    blackQueens.append(value)
                }
            }
            
            return blackQueens.count
        }
        
        return 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == whiteCheckersCollectionView {
            guard let cell = whiteCheckersCollectionView.dequeueReusableCell(withReuseIdentifier: "CheckerCollectionViewCell", for: indexPath) as? CheckerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if SettingsManager.shared.savedWhiteChecker == whiteCheckersImageName[indexPath.row] {
                
                cell.checkedImage.isHidden = false
            }
            
            cell.setupImage(checkerImage: UIImage(named: whiteCheckersImageName[indexPath.row])!)
            
            return cell
        }
        
        if collectionView == whiteCheckersQueenContollerView {
            guard let cell = whiteCheckersQueenContollerView.dequeueReusableCell(withReuseIdentifier: "CheckerCollectionViewCell", for: indexPath) as? CheckerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if SettingsManager.shared.savedWhiteCheckerQueen == whiteQueens[indexPath.row] {
                
                cell.checkedImage.isHidden = false
            }
            
            cell.setupImage(checkerImage: UIImage(named: whiteQueens[indexPath.row])!)
            
            return cell
        }
        
        if collectionView == blackCheckersCollectionView {
            guard let cell = blackCheckersCollectionView.dequeueReusableCell(withReuseIdentifier: "CheckerCollectionViewCell", for: indexPath) as? CheckerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if SettingsManager.shared.savedBlackChecker == blackCheckersImageName[indexPath.row] {
                
                cell.checkedImage.isHidden = false
            }
            
            cell.setupImage(checkerImage: UIImage(named: blackCheckersImageName[indexPath.row])!)
            
            return cell
        }
        
        if collectionView == blackCheckersQueenContollerView {
            guard let cell = blackCheckersQueenContollerView.dequeueReusableCell(withReuseIdentifier: "CheckerCollectionViewCell", for: indexPath) as? CheckerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if SettingsManager.shared.savedBlackCheckerQueen == blackQueens[indexPath.row] {
                
                cell.checkedImage.isHidden = false
            }
            
            cell.setupImage(checkerImage: UIImage(named: blackQueens[indexPath.row]))
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == whiteCheckersCollectionView {
            
            SettingsManager.shared.savedWhiteChecker = whiteCheckersImageName[indexPath.row]
            
            guard let string = SettingsManager.shared.savedWhiteChecker else {return }
            
            SettingsManager.shared.savedWhiteCheckerQueen = "\(String(describing: string))_queen_1"
            
            whiteCheckersQueenContollerView.reloadData()
            whiteCheckersCollectionView.reloadData()
        }
        
        if collectionView == whiteCheckersQueenContollerView {
            
            
        }

        if collectionView == blackCheckersCollectionView {
            
            SettingsManager.shared.savedBlackChecker = blackCheckersImageName[indexPath.row]
            
            guard let string = SettingsManager.shared.savedBlackChecker else {return }
            
            SettingsManager.shared.savedBlackCheckerQueen = "\(String(describing: string))_queen_1"
            
            blackCheckersQueenContollerView.reloadData()
            blackCheckersCollectionView.reloadData()

        }
        
    }
 
}

