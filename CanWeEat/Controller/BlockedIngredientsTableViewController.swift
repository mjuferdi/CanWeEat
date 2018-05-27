//
//  BlockedIngredientsTableViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 27.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BlockedIngredientsTableViewController: UITableViewController, UISearchBarDelegate {

    var blockedIngredients = ["Alcohol","B2B","Gelatine"]
    let baseURL = "https://api.mjuan.info/product/haram"
    let ingredientsData = BlockedIngredientsData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBlockedIngredients(url: baseURL)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsData.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath)
        cell.textLabel?.text = ingredientsData.data[indexPath.row]
        return cell
    }
    
    // MARK: - Networking
    func getBlockedIngredients(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the blocked ingredients data")
                //print(response)
                let blockedIngredientsJSON : JSON = JSON(response.result.value!)
                self.updateBlockedIngredientsData(json: blockedIngredientsJSON)
                
            } else {
                print("Errorr:  \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateBlockedIngredientsData(json: JSON) {
        if let ingredientsResult = json.array {
            for data in 0...ingredientsResult.count - 1 {
                ingredientsData.data.append(ingredientsResult[data].string!)
            }
        } else {
            print("Ingredients Unavailable")
        }
        tableView.reloadData()
    }
}
