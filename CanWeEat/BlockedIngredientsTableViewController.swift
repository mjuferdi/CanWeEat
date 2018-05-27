//
//  BlockedIngredientsTableViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 27.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit

class BlockedIngredientsTableViewController: UITableViewController, UISearchBarDelegate {

    var blockedIngredients = ["Alcohol","B2B","Gelatine"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedIngredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath)
        cell.textLabel?.text = blockedIngredients[indexPath.row]
        return cell
    }
}
