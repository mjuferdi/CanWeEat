//
//  ViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 27.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundHome: UIView!
    @IBOutlet weak var blockedIngredientsButton: UIButton!
    @IBOutlet weak var barcodeScanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        let img = UIImage()
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        navBar.isTranslucent = true
        navBar.shadowImage = img
        navBar.setBackgroundImage(img, for: .default)
    }
    
    func updateUI() {
        let colors: [UIColor] = [
            UIColor.flatOrange,
            UIColor.flatWhite
        ]
        
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        backgroundHome.layer.cornerRadius = 10.0
        backgroundHome.layer.masksToBounds = true
        blockedIngredientsButton.layer.cornerRadius = 25.0
        blockedIngredientsButton.layer.masksToBounds = true
        barcodeScanButton.layer.cornerRadius = 25.0
        barcodeScanButton.layer.masksToBounds = true
    }
    
    @IBAction func showIngredientsButton(_ sender: UIButton) {
    
    }
    
}

