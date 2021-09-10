//
//  CheckerCollectionViewCell.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 18.08.21.
//

import UIKit

class CheckerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkerImageView: UIImageView!
    @IBOutlet weak var checkedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkerImageView.image = checkedImage.image?.withRenderingMode(.alwaysTemplate)
        checkedImage.layer.masksToBounds = true
        checkedImage.layer.cornerRadius = checkedImage.frame.height / 2
        checkedImage.backgroundColor = .clear
        checkedImage.tintColor = #colorLiteral(red: 0.407904923, green: 0.4077112079, blue: 0.4207046926, alpha: 1)
        checkedImage.backgroundColor = #colorLiteral(red: 0.9375841618, green: 0.9127509594, blue: 0.930468142, alpha: 1)
        checkedImage.isHidden = true
        
    }
    
    func setupImage(checkerImage: UIImage?) {

        checkerImageView.layer.masksToBounds = true
        checkerImageView.layer.cornerRadius = checkerImageView.frame.height / 2
        checkerImageView.image = checkerImage
        checkerImageView.contentMode = .scaleAspectFill
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        checkedImage.isHidden = true
        
    }

}
