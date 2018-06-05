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
import SVProgressHUD
import ChameleonFramework

class ProductInfoViewController: UIViewController {

    var allowed: Bool = false
    var found: Bool = false
    
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var ingLabel: UILabel?
    @IBOutlet weak var ingredientTextView: UITextView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingNavbar()
        isBarcodeAvailable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set("", forKey: "Barcode")
        updateUILabel()
    }
    
    func isBarcodeAvailable() {
        guard let code = UserDefaults.standard.string(forKey: "Barcode") else{fatalError()}
        let url = URL()
        let barcode = code
        
        if barcode != "" {
            getProductInformation(url: url.baseURL + barcode)
        } else if barcode == "" {
            print("Barcode unavailable")
            alertShowUp(title: "Please Scan", message: "To get the product information, please scan the barcode first. Click the button on the top corner.")
        }
    }
    
    // MARK: Networking
    func getProductInformation(url: String) {
        print(url)
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the product information")
                let productInfoJSON: JSON = JSON(response.result.value!)
                self.updateProductInformation(json: productInfoJSON)
                //print(productInfoJSON)
                SVProgressHUD.dismiss()
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.alertShowUp(title: "No Internet Connection", message: "Please connect to the Internet to continue.")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updateProductInformation(json: JSON) {
        if let productStatus = json["status"].string {
            let title = json["title"].stringValue
            let ingredients = json["ingredient"].stringValue
            let productInfo = Product(productStatus: productStatus, productTitle: title, productIngredient: ingredients)
            setLabelProductInfo(status: productInfo.status , title: productInfo.title, ingredients: productInfo.ingredient)
            
            if let haramIngredient = json["haramIngredient"].string {
                //product.haramIngredient = haramIngredient
            }
        }
        else if let notAllowed = json["notAllowed"].bool {
            allowed = notAllowed
            setLabelNotAllowed(allowed: notAllowed)
        }
        else if let notFound = json["notFound"].bool{
            found = notFound
            setLabelNotFound(found: notFound)
        }
        else {
            return
        }
    }
    
    // MARK: Update UI
    
    func setLabelProductInfo(status: String, title: String, ingredients: String) {
        titleLabel?.text = title
        ingLabel?.text = "Ingredients:"
        ingredientTextView?.text = ingredients

        if status == "hallal" {
            statusLabel?.text = "Yes, you can consume it :)"
            statusLabel?.textColor = FlatGreen()
        } else {
            statusLabel?.text = "No, you can not consume it :("
            statusLabel?.textColor = FlatRed()
        }
    }
    
    func setLabelNotAllowed(allowed: Bool) {
        if allowed == true {
            statusLabel?.text = "Non-Edible Product"
        }
    }
    
    func setLabelNotFound(found: Bool) {
        if found == true {
            statusLabel?.text = "Products information unavailable"
        }
    }
    
    // Set UILabel to default
    func updateUILabel() {
        statusLabel?.text = ""
        statusLabel?.textColor = UIColor.black
        titleLabel?.text = ""
        ingLabel?.text = ""
        ingredientTextView?.text = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func settingNavbar() {
        let img = UIImage()
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        navBar.isTranslucent = false
        navBar.shadowImage = img
        navBar.setBackgroundImage(img, for: .default)
        navBar.barTintColor = FlatOrange()
        navBar.tintColor = ContrastColorOf(FlatOrange(), returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(FlatOrange(), returnFlat: true)]
    }
    
    // MARK: Alert method for any error
    
    func alertShowUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true)
    }
}
