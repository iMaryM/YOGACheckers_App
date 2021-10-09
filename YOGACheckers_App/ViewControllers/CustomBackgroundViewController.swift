//
//  CustomBackgroundViewController.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 21.08.21.
//

import UIKit

class CustomBackgroundViewController: UIViewController {

    @IBOutlet weak var chooseBackground: UISegmentedControl!
    @IBOutlet weak var viewOfColors: UIView!
    @IBOutlet weak var viewOfImages: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var backButton: UIButton!
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setTitle("button_back".localized(by: language), for: .normal)

        
        setupChooseBackground()
        
    }
    
    private func setupChooseBackground() {
        chooseBackground.selectedSegmentIndex = 0
        chooseBackground.setTitle("text_colors".localized(by: language), forSegmentAt: 0)
        chooseBackground.setTitle("text_images".localized(by: language), forSegmentAt: 1)
        
        let attrs: [NSAttributedString.Key : Any] = [   .font : UIFont(name: "StyleScript-Regular", size: 18) ?? UIFont.systemFont(ofSize: 24),
                                                        .foregroundColor : UIColor(red: 84 / 255, green: 85 / 255, blue: 100 / 255, alpha: 1)
                                                    ]
        
        chooseBackground.setTitleTextAttributes(attrs, for: .normal)
        blur.isHidden = true
        viewOfImages.isHidden = true
        viewOfColors.isHidden = true
    }
    
    private func setupDataPicker() {
        
        
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let picker = UIImagePickerController()
            picker.delegate = self
            
            presentAlertController(with: "alert_add_imge".localized(by: language), message: nil, preferredStyle: .actionSheet, isUsedTextField: false, actionButtons:
                                    UIAlertAction(title: "alert_button_library".localized(by: language), style: .default, handler: { _ in
                                        picker.sourceType = .photoLibrary
                                        self.present(picker, animated: true, completion: nil)
            }),
            
                                   UIAlertAction(title: "alert_button_ camera".localized(by: language), style: .default, handler: { _ in
                                    
                                    #if targetEnvironment(simulator)
                                    print("error")
                                    #else
                                    picker.sourceType = .camera
                                    self.present(picker, animated: true, completion: nil)
                                    #endif
                                    
            }),
                                   UIAlertAction(title: "alert_button_cancel".localized(by: language), style: .cancel, handler: nil))
            
            viewOfColors.isHidden = true
            viewOfImages.isHidden = false
            colorsCollectionView.isHidden = true
            blur.isHidden = false
        } else {
            viewOfColors.isHidden = true
            viewOfImages.isHidden = true
        }
        
    }
    
    
    @IBAction func goToSettings(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CustomBackgroundViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //действия по нажатию на изображение в галерее с фото
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //сохранение в файл
        guard let image = info[.originalImage] else { return }
        
        SettingsManager.shared.savedBackgroungOfCheckersView = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //действие для кнопки Cancel на галерее с фотами
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
