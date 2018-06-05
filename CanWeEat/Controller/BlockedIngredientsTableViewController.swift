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
import ChameleonFramework

class BlockedIngredientsTableViewController: UITableViewController, UISearchBarDelegate {


    @IBOutlet weak var searchBar: UISearchBar!
    
    var ingredientsData = BlockedIngredients()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL()
        getBlockedIngredients(url: url.baseURL + "haram")
        tableView.separatorStyle = .none
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsData.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath)
        cell.textLabel?.text = ingredientsData.filteredData[indexPath.row].capitalized
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return cell
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
        searchBar.barTintColor = FlatOrange()
    }
    
    // MARK: - Networking
    func getBlockedIngredients(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the blocked ingredients data")
                //print(response)
                let blockedIngredientsJSON: JSON = JSON(response.result.value!)
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
                ingredientsData.filteredData.append(ingredientsResult[data].string!)
            }
        } else {
            print("Ingredients Unavailable")
        }
        tableView.reloadData()
    }
    
    //MARK: - Search bar methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ingredientsData.filteredData = searchText.isEmpty ? ingredientsData.data : ingredientsData.data.filter({ (dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
}


