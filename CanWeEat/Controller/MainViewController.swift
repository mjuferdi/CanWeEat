//
//  TableViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 28.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIColor()
    }
    
    func updateUIColor() {
        let colors: [UIColor] = [
            UIColor.flatOrange,
            UIColor.flatWhite
        ]
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        navigationController?.navigationBar.barTintColor = FlatOrange()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        blockedIngredientsButton.layer.cornerRadius = 25.0
        blockedIngredientsButton.layer.masksToBounds = true
        barcodeScanButton.layer.cornerRadius = 25.0
        barcodeScanButton.layer.masksToBounds = true
        background.layer.cornerRadius = 10.0
        background.layer.masksToBounds = true
    }
}
