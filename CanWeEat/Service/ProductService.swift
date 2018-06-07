//
//  ProductService.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 31.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductService {
    
    static let productService = ProductService()
    
    var STATUS_FROM_API = ""
    var TITLE_FROM_API = ""
    var INGREDIENT_FROM_API = ""
    var HARAM_INGREDIENT_FROM_API = ""
    var NOT_ALLOWED_FROM_API = true


    func getProductInformation(code: String) {
        let url = "https://api.mjuan.info/product/\(code)"

        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the product information")
                let productInfoJSON: JSON = JSON(response.result.value!)
                //print(productInfoJSON)
                self.updateProductInformation(json: productInfoJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateProductInformation(json: JSON) {
        if let productInfo = json["status"].string {
            let status = productInfo
            let title = json["title"].stringValue
            let ingredient = json["ingredient"].stringValue
            print(status, title)

            ProductService.productService.STATUS_FROM_API = status
            ProductService.productService.TITLE_FROM_API = title
            ProductService.productService.INGREDIENT_FROM_API = ingredient

            if let haramIngredient = json["haramIngredient"].string {
                let haramIngredient = haramIngredient
                print(haramIngredient)
                ProductService.productService.HARAM_INGREDIENT_FROM_API = haramIngredient
            }
        }
        else if let notAllowed = json["notAllowed"].bool {
            let notAllowed = notAllowed
            
            ProductService.productService.NOT_ALLOWED_FROM_API = notAllowed
            
            if notAllowed == true {
                print("You can't eat the product")
            }
        }
        else {
            print("Information unavailable")
        }
        
        NotificationCenter.default.post(name: Notification.Name("ProductNotification"), object: nil)

    }
}
