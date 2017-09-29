//
//  PantryHistoryViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-18.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addShoppingButton: UIBarButtonItem!
    
    @IBOutlet weak var archiveTable: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var archiveArray = [PantryItem]()
    var filteredArray = [PantryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Historic Items"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        // Do any additional setup after loading the view.
        
        // set data source for tables
        archiveTable.dataSource = self
        archiveTable.delegate = self
    
        // register cell nib
        let cellNib = UINib(nibName: "PantryArchiveCell", bundle: nil)
        archiveTable.register(cellNib, forCellReuseIdentifier: "PantryArchiveCell")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [Constants.scopeName, Constants.scopeGroup]
        searchController.searchBar.delegate = self
        archiveTable.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload new data
        refreshData()
    }
    
    func refreshData() {
        archiveArray = getGroupPantryItemArchived()
        archiveTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredArray.count, of: archiveArray.count)
            return filteredArray.count
        } else {
            searchFooter.setNotFiltering()
            return archiveArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryArchiveCell", for: indexPath) as! PantryArchiveCell
        
        let item: PantryItem
        
        if isFiltering() {
            item = filteredArray[indexPath.item]
        } else {
            item = archiveArray[indexPath.item]
        }
        cell.itemName.text = item.name
        if (item.toggle == 0) {
            cell.checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
        }
        
        let date = item.archive
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        cell.itemExpire.text = "Archived on " + dateFormatter.string(from: date)
        
        cell.groupImage.image = UIImage(named: Constants.pantryIconMap[item.group]!)
        
        cell.observer = self
        cell.pantryItem = item

        return cell
    }
    
    // add all toggled items to shopping list
    @IBAction func addShoppingAction(_ sender: Any) {
        var response = -1
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm to add the selected items to your current shopping list?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            // get all toggled items
            let items = getToggledPantryItems()
            
            // add toggled items to shopping list
//**        Need to get a response from addPantryItems to signal success
            addPantryItemsToShoppingList(items)
            response = 1
            
            self.refreshData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        if (response != -1) {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Selected pantry items have been added to the active shopping list.", message: "", preferredStyle: .alert)
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    // MARK: Search Bar Configuration
    func filterContentForSearchText(searchText: String, scope: String) {
        
        // Filter the array using the filter method
        if self.archiveArray.isEmpty {
            self.filteredArray = []
            return
        }
        self.filteredArray = self.archiveArray.filter({( anItem: PantryItem) -> Bool in
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
        
        archiveTable.reloadData()
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

extension PantryHistoryViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension PantryHistoryViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
