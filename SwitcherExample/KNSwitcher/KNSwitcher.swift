//
//  Switcher.swift
//  SwitcherExample
//
//  Created by Khoi Nguyen Nguyen on 11/2/15.
//  Copyright © 2015 Khoi Nguyen Nguyen. All rights reserved.
//

import UIKit


class KNSwitcher: UIControl {
    
    private var button: UIButton!
    
    var buttonLeftConstraint: NSLayoutConstraint!
    
    @IBInspectable var toggleScale: CGFloat = 0.8
    @IBInspectable var animDuration: Double = 0.35
    @IBInspectable var showShadowWhenSelected: Bool = true
    @IBInspectable var originalImage: UIImage? {
        didSet {
            guard button != nil else { return }
            button.setImage(originalImage, for: .normal)
        }
    }
    @IBInspectable var selectedImage: UIImage? {
        didSet {
            guard button != nil else { return }
            button.setImage(selectedImage, for: .selected)
        }
    }
    @IBInspectable var selectedColor: UIColor = UIColor(red: 126/255.0, green: 134/255.0, blue: 249/255.0, alpha: 1) {
        didSet {
            guard button != nil else { return }
            if button.isSelected {
                button.backgroundColor = selectedColor
            }
        }
    }
    @IBInspectable var originalColor: UIColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 211/255.0, alpha: 1) {
        didSet {
            guard button != nil else { return }
            if !button.isSelected {
                button.backgroundColor = originalColor
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {            
            sendActions(for: .valueChanged)
        }
    }
    
    private var offCenterPosition: CGFloat = 0.0
    private var onCenterPosition: CGFloat = 0.0
    private var firstLayout: Bool = true
    
    init(frame: CGRect, on: Bool) {
        super.init(frame: frame)
        self.isSelected = on
        commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(switcherButtonTouch), for: .touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        
        let spacingRatio = ((1.0 - toggleScale) / 2)
        offCenterPosition = self.bounds.height * spacingRatio
        onCenterPosition = self.bounds.width - (self.bounds.height * (1.0 - spacingRatio))
        
        if isSelected {
            self.button.backgroundColor = selectedColor
        } else {
            self.button.backgroundColor = originalColor
        }
        
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        initLayout()
        animationSwitcherButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2        
        button.layer.cornerRadius = button.bounds.height / 2
        firstLayout = false
    }
    
    private func initLayout() {
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLeftConstraint = button.leftAnchor.constraint(equalTo: self.leftAnchor)
        buttonLeftConstraint.isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: toggleScale).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setImages(onImage:UIImage? , offImage :UIImage?) {
        button.setImage(offImage, for: .normal)
        button.setImage(onImage, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switcherButtonTouch() {
        isSelected = !isSelected
        animationSwitcherButton()
    }
    
    func animationSwitcherButton() {
        let duration = firstLayout ? 0.0 : animDuration
        
        if isSelected {
            // Rotate animation
            if duration > 0 {
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = -CGFloat(Double.pi)
                rotateAnimation.toValue = 0.0
                rotateAnimation.duration = max(0.0, duration - 0.05)
                rotateAnimation.isCumulative = false;
                self.button.layer.add(rotateAnimation, forKey: "rotate")
            }
            
            // Translation animation
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                self.button.isSelected = true
                self.buttonLeftConstraint.constant = self.onCenterPosition
                self.button.backgroundColor = self.selectedColor
                self.layoutIfNeeded()
            }, completion: { [weak self] finish in
                guard let `self` = self else { return }
                if self.showShadowWhenSelected {
                    self.button.layer.shadowOffset = CGSize(width: 0, height: 0.2)
                    self.button.layer.shadowOpacity = 0.3
                    self.button.layer.shadowRadius = self.offCenterPosition < 0 ? self.button.bounds.height * 0.1 : self.offCenterPosition
                    self.button.layer.shadowPath = UIBezierPath(roundedRect: self.button.layer.bounds, cornerRadius: self.button.frame.height / 2).cgPath
                }
            })
        } else {
            // Clear Shadow
            self.button.layer.shadowOffset = CGSize.zero
            self.button.layer.shadowOpacity = 0
            self.button.layer.shadowRadius = self.button.frame.height / 2
            self.button.layer.cornerRadius = self.button.frame.height / 2
            self.button.layer.shadowPath = nil
            
            if duration > 0 {
                // Rotate animation
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = -CGFloat(Double.pi)
                rotateAnimation.duration = max(0.0, duration - 0.05)
                rotateAnimation.isCumulative = false;
                self.button.layer.add(rotateAnimation, forKey: "rotate")
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                self.button.isSelected = false
                self.buttonLeftConstraint.constant = self.offCenterPosition
                self.button.backgroundColor = self.originalColor
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
