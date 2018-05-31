//
//  ScannerViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 29.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework

class ProductInfoViewController: UIViewController {

    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
    }
    
    // MARK: Networking
    func getProductInformation(url: String) {
        print(url)
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the product information")
                let productInfoJSON: JSON = JSON(response.result.value!)
                print(productInfoJSON)
                self.updateProductInformation(json: productInfoJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateProductInformation(json: JSON) {
        if let productInfo = json["status"].string {
            product.status = productInfo
            product.title = json["title"].stringValue
            product.ingredient = json["ingredient"].stringValue
            
//            print(product.status)
//            print(product.title)
//            print(product.ingredient)
            
            if let haramIngredient = json["haramIngredient"].string {
                product.haramIngredient = haramIngredient
                print(product.haramIngredient)
            }
        }
        else if let notAllowed = json["notAllowed"].bool {
            product.notAllowed = notAllowed
            if product.notAllowed == true {
                print("You can't eat the product")
            }
        }
        else {
            print("Information unavailable")
        }
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
