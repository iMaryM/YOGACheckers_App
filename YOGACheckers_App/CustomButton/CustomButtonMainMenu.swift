//
//  CustomButtonMainMenu.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 22.08.21.
//

import UIKit

@IBDesignable
class CustomButtonMainMenu: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameButtonLabel: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor )
            }
            
            return .clear
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set {
            self.layer.shadowColor = newValue.cgColor
        }
        
        get {
            if let cgColor = self.layer.shadowColor {
                return UIColor(cgColor: cgColor )
            }
            
            return .clear
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }
        
        get {
            return self.layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }
        
        get {
            return self.layer.shadowOpacity
        }
    }
    
    @IBInspectable var text: String {
        set {
            self.nameButtonLabel.text = newValue
        }
        get {
            return self.nameButtonLabel.text ?? "Label"
        }
    }
    
    @IBInspectable var textColor: UIColor {
        set {
            self.nameButtonLabel.textColor = newValue
        }
        get {
            return self.nameButtonLabel.textColor ?? .black
        }
    }
    
    @IBInspectable var fontSize: CGFloat
    {
        set {
            self.nameButtonLabel.font = UIFont(name: "StyleScript-Regular", size: newValue)
        }
        get {
            return 14.0
        }
    }
    
    @IBInspectable var textFont: UIFont {
        set {
            self.nameButtonLabel.font = newValue
        }
        get {
            return self.nameButtonLabel.font
        }
    }
    
    @IBInspectable var image: UIImage? {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    var buttonDidTap: (() -> ())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle(for: CustomButtonMainMenu.self).loadNibNamed("CustomButtonMainMenu", owner: self, options: nil)
        containerView.frame = self.bounds
        self.addSubview(containerView)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        buttonDidTap?()
    }
    
}
