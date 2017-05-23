//
//  Switcher.swift
//  SwitcherExample
//
//  Created by Khoi Nguyen Nguyen on 11/2/15.
//  Copyright © 2015 Khoi Nguyen Nguyen. All rights reserved.
//

import UIKit

@objc public protocol KNSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: KNSwitcher, value: Bool)
}

@objc public class KNSwitcher: UIView {

    var button: UIButton!
    var buttonLeftConstraint: NSLayoutConstraint!
    @objc public var delegate: KNSwitcherChangeValueDelegate?
    var firstLaunch = true
    
    @IBInspectable var on: Bool = false
    @IBInspectable var originalImage:UIImage?
    @IBInspectable var selectedImage:UIImage?
    @IBInspectable var selectedColor:UIColor = UIColor(red: 126/255.0, green: 134/255.0, blue: 249/255.0, alpha: 1)
    @IBInspectable var originalColor:UIColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 211/255.0, alpha: 1)
    
    @objc public var enabled: Bool = true {
        willSet (newValue) {
            button.enabled = newValue
            
            if newValue {
                self.button.layer.shadowOffset = CGSize(width: 0, height: 0.2)
                self.button.layer.shadowOpacity = 0.3
                self.button.layer.shadowRadius = 2.0
                self.button.layer.cornerRadius = self.button.frame.height / 2
                self.button.layer.shadowPath = UIBezierPath.init(roundedRect: self.button.layer.bounds, cornerRadius: self.button.frame.height / 2).CGPath
            }
        }
    }
    
    private var offCenterPosition: CGFloat!
    private var onCenterPosition: CGFloat!
    
     init(frame: CGRect, on: Bool) {
        super.init(frame: frame)
        self.on = on
        commonInit()
    }
    
    override public func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        button = UIButton.init(type: .Custom)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), forControlEvents: .TouchUpInside)
        button.enabled = false
        button.setImage(originalImage, forState: .Normal)
        button.setImage(selectedImage, forState: .Selected)
        offCenterPosition = self.bounds.height * 0.1
        onCenterPosition = self.bounds.width - (self.bounds.height * 0.9)
        
        if on == true {
            self.button.backgroundColor = selectedColor
        } else {
            self.button.backgroundColor = originalColor
        }
        
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.whiteColor()
        }
        initLayout()
        animationSwitcherButton()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private func initLayout() {
        button.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        buttonLeftConstraint = button.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        buttonLeftConstraint.active = true
        button.heightAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: 0.8).active = true
        button.widthAnchor.constraintEqualToAnchor(button.heightAnchor, multiplier: 1).active = true
    }
    
    func setImages(onImage:UIImage? , offImage :UIImage?) {
            button.setImage(offImage, forState: .Normal)
            button.setImage(onImage, forState: .Selected)
        }   
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func switcherButtonTouch(_ sender: AnyObject) {
        on = !on
        animationSwitcherButton()
        delegate?.switcherDidChangeValue(self, value: on)
    }
    
    func animationSwitcherButton() {
        if on == true {
            if firstLaunch == false {
                // Rotate animation
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = -CGFloat(M_PI)
                rotateAnimation.toValue = 0.0
                rotateAnimation.duration = 0.45
                rotateAnimation.cumulative = false;
                self.button.layer.addAnimation(rotateAnimation, forKey: "rotate")
            } else {
                firstLaunch = false
            }
            
            
            // Translation animation
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.button.selected = true
                self.buttonLeftConstraint.constant = self.onCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.selectedColor
                }, completion: { (finish:Bool) -> Void in
            })
        } else {
            // Clear Shadow
            if firstLaunch == false {
                // Rotate animation
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = -CGFloat(M_PI)
                rotateAnimation.duration = 0.45
                rotateAnimation.cumulative = false;
                self.button.layer.addAnimation(rotateAnimation, forKey: "rotate")
            } else {
                firstLaunch = false
            }
            
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.button.selected = false
                self.buttonLeftConstraint.constant = self.offCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.originalColor
                }, completion: { (finish:Bool) -> Void in
            })
        }
    }
}

