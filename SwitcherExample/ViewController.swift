//
//  ViewController.swift
//  SwitcherExample
//
//  Created by Khoi Nguyen Nguyen on 11/2/15.
//  Copyright © 2015 Khoi Nguyen Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switcher = KNSwitcher(frame: CGRect(x: 100, y: 100, width: 200, height: 80), on: false)
        switcher.animDuration = 1.5
        switcher.showShadowWhenSelected = true
        switcher.toggleScale = 0.9
        switcher.setImages(onImage: UIImage(named: "Checkmark"), offImage: UIImage(named: "Delete"))
        switcher.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(switcher)
    }

    @objc @IBAction func switchValueChanged(sender: UIControl) {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            guard let `self` = self else { return }
            
            let alert = UIAlertController(title: nil, message: "Value changed - \(sender.isSelected)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        
    }
}

