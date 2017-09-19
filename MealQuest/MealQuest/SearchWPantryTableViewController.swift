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
    
    var itemArray = [PantryItem]()
    
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
        
        itemArray = getUniqueActivePantryItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    // get unique list of pantry items (base case-insensitive name)
    func getUniqueActivePantryItems() -> [PantryItem] {
        let items = SQLiteDB.instance.getAllPantryItems()
        return Array(Set(items))
    }

    func refreshData() {
        itemArray = getUniqueActivePantryItems()
        itemTable.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryArchiveCell", for: indexPath) as! PantryArchiveCell

        cell.itemName.text = itemArray[indexPath.item].name
        if (itemArray[indexPath.item].search == 0) {
            cell.checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
        }
        
        let date = itemArray[indexPath.item].expiration
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        cell.itemExpire.text = "Expiring on " + dateFormatter.string(from: date)
        
        cell.groupImage.image = UIImage(named: itemArray[indexPath.item].group)
        
        cell.search = true
        cell.searchObserver = self
        cell.pantryItem = itemArray[indexPath.item]

        return cell
    }
    
    // send checked pantry items to search
    @IBAction func searchWithPantryAction(_ sender: Any) {
        
        // get all search pantry items
        let items = SQLiteDB.instance.getSearchPantryItems()
        
        // revert search status toggled items
        _ = SQLiteDB.instance.revertSearchPantryItems()
        
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
