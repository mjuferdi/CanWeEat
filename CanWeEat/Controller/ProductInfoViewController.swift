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

    let baseUrl = "https://api.mjuan.info/product/"
    var product = Product()
    
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var ingLabel: UILabel?
    @IBOutlet weak var ingredientTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
        isBarcodeAvailable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set("", forKey: "Barcode")
    }
    
    func isBarcodeAvailable() {
        if let code = UserDefaults.standard.string(forKey: "Barcode") {
            product.barcode = code
            print(product.barcode)
            getProductInformation(url: baseUrl + product.barcode)
        } else {
            print("Barcode unavailable")
        }
    }
    
    // MARK: Networking
    func getProductInformation(url: String) {
        print(url)
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the product information")
                let productInfoJSON: JSON = JSON(response.result.value!)
                //print(productInfoJSON)
                self.updateProductInformation(json: productInfoJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
                let alert = UIAlertController(title: "Please Scan", message: "To get the product information, please scan the barcode first.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            }
        }
    }
    
    func updateProductInformation(json: JSON) {
        if let productInfo = json["status"].string {
            product.status = productInfo
            product.title = json["title"].stringValue
            product.ingredient = json["ingredient"].stringValue
            
            print(product.status)
            
            titleLabel?.text = product.title
            statusLabel?.text = product.status.uppercased()
            ingLabel?.text = "Ingredients:"
            ingredientTextView?.text = product.ingredient
            
            if product.status == "hallal" {
                statusLabel?.textColor = FlatGreen()
            } else {
                statusLabel?.textColor = FlatRed()
            }
            
            if let haramIngredient = json["haramIngredient"].string {
                product.haramIngredient = haramIngredient
                print(product.haramIngredient)
            }
        }
        else if let notAllowed = json["notAllowed"].bool {
            product.notAllowed = notAllowed
            if product.notAllowed == true {
                statusLabel?.text = "You can't eat the product"
                statusLabel?.textColor = FlatRed()
                titleLabel?.text = ""
                ingLabel?.text = ""
                ingredientTextView?.text = ""
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
