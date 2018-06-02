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
        updateUILabel()
    }
    
    func isBarcodeAvailable() {
        guard let code = UserDefaults.standard.string(forKey: "Barcode") else{fatalError()}
        product.barcode = code

        if product.barcode != "" {
            print(product.barcode)
            getProductInformation(url: baseUrl + product.barcode)
        } else if product.barcode == "" {
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
                print(productInfoJSON)
                SVProgressHUD.dismiss()
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.alertShowUp(title: "No Internet Connection", message: "Please connect to the Internet to continue.")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updateProductInformation(json: JSON) {
        if let productInfo = json["status"].string {
            product.status = productInfo
            product.title = json["title"].stringValue
            product.ingredient = json["ingredient"].stringValue
            
            setLabelProductInfo()
            
            if let haramIngredient = json["haramIngredient"].string {
                product.haramIngredient = haramIngredient
            }
        }
        else if let notAllowed = json["notAllowed"].bool {
            product.notAllowed = notAllowed
            setLabelNotAllowed()
        }
        else if let notFound = json["notFound"].bool{
            product.notFound = notFound
            setLabelNotFound()
        }
        else {
            return
        }
    }
    
    // MARK: Update UI
    
    func setLabelProductInfo() {
        titleLabel?.text = product.title
        statusLabel?.text = product.status.uppercased()
        ingLabel?.text = "Ingredients:"
        ingredientTextView?.text = product.ingredient
        
        if product.status == "hallal" {
            statusLabel?.textColor = FlatGreen()
        } else {
            statusLabel?.textColor = FlatRed()
        }
    }
    
    func setLabelNotAllowed() {
        if product.notAllowed == true {
            statusLabel?.text = "Non-Edible Product"
            titleLabel?.text = ""
            ingLabel?.text = ""
            ingredientTextView?.text = ""
        }
    }
    
    func setLabelNotFound() {
        if product.notFound == true {
            statusLabel?.text = "Products information unavailable"
            statusLabel?.sizeToFit()
        }
    }
    
    func updateUILabel() {
        statusLabel?.text = ""
        statusLabel?.textColor = UIColor.black
        titleLabel?.text = ""
        ingLabel?.text = ""
        ingredientTextView?.text = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
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
    
    // MARK: Alert method for any error
    
    func alertShowUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true)
    }
}
