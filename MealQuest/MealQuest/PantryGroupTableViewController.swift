//
//  PantryGroupTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-10.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryGroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var itemTable: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var newItemButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var group = "Group View"
    
    var numSections = ["Expiring", "All Other"]
    var expiringArray = [PantryItem]()
    var filteredExpiringArray = [PantryItem]()
    var otherArray = [PantryItem]()
    var filteredOtherArray = [PantryItem]()
    var allItemsArray = [[PantryItem]]()
    var allFilteredItemsArray = [[PantryItem]]()
    
    var viewItem = PantryItem(id: 1)
    
    func redrawTable( ) {
        expiringArray = getGroupPantryItemStale(pantryGroup: group)
        otherArray = getGroupPantryItemFresh(pantryGroup: group)
        allItemsArray = [expiringArray, otherArray]
        itemTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.itemTable.dataSource = self
        self.itemTable.delegate = self
        
        let cellNib = UINib(nibName: "PantryGroupCell", bundle: nil)
        self.itemTable.register(cellNib, forCellReuseIdentifier: "PantryGroupCell")
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = group
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        expiringArray = getGroupPantryItemStale(pantryGroup: group)
        otherArray = getGroupPantryItemFresh(pantryGroup: group)
        allItemsArray = [expiringArray, otherArray]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [Constants.scopeName, Constants.scopeGroup]
        searchController.searchBar.delegate = self
        itemTable.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redrawTable()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: (filteredOtherArray.count + filteredExpiringArray.count), of: (otherArray.count + expiringArray.count))
            return allFilteredItemsArray[section].count
        } else {
            searchFooter.setNotFiltering()
            return allItemsArray[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < numSections.count {
            return numSections[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryGroupCell", for: indexPath) as! PantryGroupCell
        
        let item: PantryItem
        
        if isFiltering() {
            item = allFilteredItemsArray[indexPath.section][indexPath.row]
        } else {
            item = allItemsArray[indexPath.section][indexPath.row]
        }
        
        let name = item.name
        let quantity = item.quantity.roundTo(places: 2)
        let unit = item.unit
        cell.itemName.text = name + " (" + "\(quantity)" + " " + unit + ")"
        
        let date = item.expiration
        let dateText = getRelativeDate(date: date)
        let last2 = dateText.substring(from:dateText.index(dateText.endIndex, offsetBy: -2))
        if (last2 == "d.") {
            cell.itemExpire.textColor = UIColor.red
        } else {
            cell.itemExpire.textColor = UIColor.gray
        }
        cell.itemExpire.text = dateText
        
        cell.icon.image = UIImage(named: Constants.pantryIconMap[item.group]!)
        
        cell.currentItem = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var currentCell: PantryItem
            
            if isFiltering() {
                currentCell = allFilteredItemsArray[indexPath.section][indexPath.row]
            } else {
                currentCell = allItemsArray[indexPath.section][indexPath.row]
            }
        
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Confirm to delete the current item from your pantry?", message: "", preferredStyle: .alert)
        
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
                archivePantryItem(pantryId: currentCell.id)
                print("Delete item from database!")
            
                // initialize new view controller and cast it as your view controller
                self.redrawTable()
            
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func badInputAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Please enter a valid quantity to consume.", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        if isFiltering() {
            viewItem = allFilteredItemsArray[indexPath.section][indexPath.row]
        } else {
            viewItem = allItemsArray[indexPath.section][indexPath.row]
        }
        
        performSegue(withIdentifier: "viewItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        if (segue.identifier == "viewItem") {
            // initialize new view controller and cast it as your view controller
            let viewVC = segue.destination as! PantryAddItemViewController
            // your new view controller should have property that will store passed value
            viewVC.viewItem = viewItem
            viewVC.viewMode = true
        } else
        
        if (segue.identifier == "addItem") {
            let addVC = segue.destination as! PantryAddItemViewController
            addVC.itemGroupSuggestion = group
        }
    }
    
    // MARK: Search Bar Configuration
    func filterContentForSearchText(searchText: String, scope: String) {
        
        // Filter the array using the filter method
        if self.otherArray.isEmpty {
            self.filteredOtherArray = []
        }
        self.filteredOtherArray = self.otherArray.filter({( anItem: PantryItem) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else if (scope == Constants.scopeName) {
                return anItem.name.lowercased().contains(searchText.lowercased())
            } else if (scope == Constants.scopeGroup) {
                return anItem.group.lowercased().contains(searchText.lowercased())
            } else {
                return true
            }
        })
        
        if self.expiringArray.isEmpty {
            self.filteredExpiringArray = []
        }
        self.filteredExpiringArray = self.expiringArray.filter({( anItem: PantryItem) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else if (scope == Constants.scopeName) {
                return anItem.name.lowercased().contains(searchText.lowercased())
            } else if (scope == Constants.scopeGroup) {
                return anItem.group.lowercased().contains(searchText.lowercased())
            } else {
                return true
            }
        })
        
        allFilteredItemsArray = [filteredExpiringArray, filteredOtherArray]
        
        itemTable.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension PantryGroupTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension PantryGroupTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
