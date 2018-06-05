//
//  HalalProduct.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 30.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import Foundation

class Product {

    var status: String = ""
    var title: String = ""
    var ingredient: String = ""
    
    init(productStatus: String, productTitle: String, productIngredient: String) {
        self.status = productStatus
        self.title = productTitle
        self.ingredient = productIngredient
    }
    
}
