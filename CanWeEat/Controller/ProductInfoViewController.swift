//
//  ScannerViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 29.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import ChameleonFramework

class ProductInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
    }
    
    func updateNavbar() {
        let img = UIImage()
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        navBar.isTranslucent = false
        navBar.shadowImage = img
        navBar.setBackgroundImage(img, for: .default)
        navBar.barTintColor = FlatOrange()
        navBar.tintColor = ContrastColorOf(FlatOrange(), returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(FlatOrange(), returnFlat: true)]
    }
}
