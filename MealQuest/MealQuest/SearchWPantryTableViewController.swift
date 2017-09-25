//
//  SearchWPantryTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class SearchWPantryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var itemTable: UITableView!
    @IBOutlet weak var searchWPantryButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pantryItemDic: [String: [PantryItem]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Pantry Items"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        // set data source for table
        itemTable.dataSource = self
        itemTable.delegate = self
    
        // register cell nib
        let cellNib = UINib(nibName: "PantryArchiveCell", bundle: nil)
        itemTable.register(cellNib, forCellReuseIdentifier: "PantryArchiveCell")
        
        getUniqueActivePantryItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    // get unique list of pantry items (base case-insensitive name)
    func getUniqueActivePantryItems() {
        for i in 0...(Constants.pantrySearchGroups.count - 1) {
            pantryItemDic[Constants.pantrySearchGroups[i]] = getGroupPantryItem(pantryGroup: Constants.pantrySearchGroups[i])
        }
    }

    func refreshData() {
        getUniqueActivePantryItems()
        itemTable.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Constants.pantrySearchGroups.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < Constants.pantrySearchGroups.count {
            return Constants.pantrySearchGroups[section]
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pantryItemDic[Constants.pantrySearchGroups[section]]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryArchiveCell", for: indexPath) as! PantryArchiveCell

        cell.itemName.text = pantryItemDic[Constants.pantrySearchGroups[indexPath.section]]?[indexPath.item].name
        if (pantryItemDic[Constants.pantrySearchGroups[indexPath.section]]?[indexPath.item].search == 0) {
            cell.checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
        }
        
        let date = pantryItemDic[Constants.pantrySearchGroups[indexPath.section]]?[indexPath.item].expiration
        let dateText = getRelativeDate(date: date!)
        let last2 = dateText.substring(from:dateText.index(dateText.endIndex, offsetBy: -2))
        if (last2 == "d.") {
            cell.itemExpire.textColor = UIColor.red
        } else {
            cell.itemExpire.textColor = UIColor.gray
        }
        cell.itemExpire.text = dateText
        cell.groupImage.image = UIImage(named: Constants.pantryIconMap[(pantryItemDic[Constants.pantrySearchGroups[indexPath.section]]?[indexPath.item].group)!]!)
        
        cell.search = true
        cell.searchObserver = self
        cell.pantryItem = pantryItemDic[Constants.pantrySearchGroups[indexPath.section]]?[indexPath.item]

        return cell
    }
    
    // send checked pantry items to search
    @IBAction func searchWithPantryAction(_ sender: Any) {
        
        // get all search pantry items
        let items = SQLiteDB.instance.getSearchPantryItems()

//** Greg comment: the revert is used to unmark the user's search selection; it resets the search flag to 0 after getting the list of items to search with just above
        // revert search status toggled items
        _ = SQLiteDB.instance.revertSearchPantryItems()
        
//**    make search on recipes with query and category -> searchWPantryRecipes(query: [String], category: String) -> [RecipeItem]

        // send this list of item names as input to search
        let query = items.map{$0.name}.joined(separator: ",")
        print(query)
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Sorry. Search functionality is not yet ready.", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }

}
