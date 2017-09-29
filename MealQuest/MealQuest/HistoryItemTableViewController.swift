//
//  HistoryItemTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class HistoryItemTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var historyItemTable: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var observer: Observer!
    
    var shoppingItemList = [ShoppingItem]()
    var filteredItemList = [ShoppingItem]()
    var detailsPassed = [String:Any]()
    var cellID = Int64()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Historic Items"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        historyItemTable.dataSource = self
        historyItemTable.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [Constants.scopeName, Constants.scopeGroup, Constants.scopeGreaterCost, Constants.scopeLesserCost]
        searchController.searchBar.delegate = self
        historyItemTable.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func refreshData() {
        shoppingItemList = getAllShoppingItems()
        historyItemTable.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredItemList.count, of: shoppingItemList.count)
            return filteredItemList.count
        } else {
            searchFooter.setNotFiltering()
            return shoppingItemList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryItemCell", for: indexPath) as! HistoryItemCell
        let item: ShoppingItem
        if isFiltering() {
            item = filteredItemList[filteredItemList.index(filteredItemList.startIndex, offsetBy: indexPath.item)]
        } else {
            item = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)]
        }
        
        cell.id = item.id
        cell.quantity = "\(item.quantity)"
        cell.unit = "\(item.unit)"
        cell.name = item.name
        cell.cost = item.itemCost
        cell.group = item.group
        cell.purchased = item.purchased
        cell.expiration = item.expirationDate
        
        cell.shoppingGroupImage.image = UIImage(named: Constants.pantryIconMap[cell.group]!)
        
        cell.itemNameLabel.text = cell.name + " (" + cell.quantity + " " + cell.unit + ")"
        cell.itemCostLabel.text = cell.cost.dollarString

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! HistoryItemCell
        
        let detailsPassed = ShoppingItem(
            listID: -1,
            itemID: -1,
            itemName: currentCell.name,
            itemCost: Double(currentCell.cost),
            unit: currentCell.unit,
            quantity: Double(currentCell.quantity)!,
            group: currentCell.group,
            purchased: currentCell.purchased,
            expirationDate: currentCell.expiration,
            repurchase: false
        )
        
        // initialize new view controller and cast it as your view controller
        let stack = self.navigationController?.viewControllers
        if ((stack?.count)! > 1) {
            // Your new view controller should have property that will store passed value
            observer.populateFields(detailsPassed)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Search Bar Configuration
    func filterContentForSearchText(searchText: String, scope: String) {
        
        // Filter the array using the filter method
        if self.shoppingItemList.isEmpty {
            self.filteredItemList = []
            return
        }
        self.filteredItemList = self.shoppingItemList.filter({( anItem: ShoppingItem) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else if (scope == Constants.scopeName) {
                return anItem.name.lowercased().contains(searchText.lowercased())
            } else if (scope == Constants.scopeGroup) {
                return anItem.group.lowercased().contains(searchText.lowercased())
            } else if (scope == Constants.scopeGreaterCost) {
                if let value = Double(searchText) {
                    return (anItem.itemCost > value)
                } else {
                    return false
                }
            } else if (scope == Constants.scopeLesserCost) {
                if let value = Double(searchText) {
                    return (anItem.itemCost < value)
                } else {
                    return false
                }
            } else {
                return true
            }
        })
        
        historyItemTable.reloadData()
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

extension HistoryItemTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension HistoryItemTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
