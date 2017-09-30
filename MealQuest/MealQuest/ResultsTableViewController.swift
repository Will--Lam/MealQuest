//
//  RecipeViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-06.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ResultsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var searchFooter: SearchFooter!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var resultsPassed = [RecipeItem]()
    var filteredResults = [RecipeItem]()
    var recipeDetails = RecipeItem(id: -1)
    var recipeIngredients = [RecipeIngredient]()
    var cellID = Int64()
    var group = "Search Results"
    
    func redrawTable( ) {
        if (group != "Search Results") {
            resultsPassed = getRecipes(category: group)
        }
        resultsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = group
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        if (group == "Search Results") {
            addRecipeButton.isEnabled = false
            addRecipeButton.isHidden = true
        } else {
            addRecipeButton.isEnabled = true
            addRecipeButton.isHidden = false
        }
        
        self.resultsTable.dataSource = self
        self.resultsTable.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [Constants.scopeName, Constants.scopeGroup, Constants.scopeGreaterCookTime, Constants.scopeLesserCookTime]
        searchController.searchBar.delegate = self
        resultsTable.tableHeaderView = searchController.searchBar
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redrawTable()
        
        if (group == "Search Results") {
            addRecipeButton.isEnabled = false
            addRecipeButton.isHidden = true
        } else {
            addRecipeButton.isEnabled = true
            addRecipeButton.isHidden = false
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredResults.count, of: resultsPassed.count)
            return filteredResults.count
        } else {
            searchFooter.setNotFiltering()
            return resultsPassed.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        
        let item: RecipeItem
        
        if isFiltering() {
            item = filteredResults[indexPath.item]
        } else {
            item = resultsPassed[indexPath.item]
        }
        
        let idVal = item.recipeID
        let titleText = item.title
        let calorieVal = item.calories
        let recipeCategory = item.primary
        
        // Configure the cell...
        cell.id = idVal
        cell.category = recipeCategory
        cell.titleLabel.text = titleText
        cell.calorieLabel.text = "\(calorieVal)"
        cell.categoryIcon.image = UIImage(named: Constants.recipeIconMap[recipeCategory]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (group != "Search Results") {
            let currentCell = tableView.cellForRow(at: indexPath)! as! ResultsTableViewCell
        
            cellID = currentCell.id as Int64
        
            if editingStyle == .delete {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Confirm to delete the recipe?", message: "", preferredStyle: .alert)
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                    let recipeItem = getRecipeDetails(recipeID: self.cellID)
                    let oldImagePath = recipeItem.imagePath
                    if (oldImagePath != "") {
                        // Need to delete the old image on success
                        do {
                            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                            // Get the Document directory path
                            let documentDirectoryPath:String = paths[0]
                            // Create a new path for the new images folder
                            let imagesDirectoryPath = documentDirectoryPath.appending("/RecipeImages")
                            let imagePath = imagesDirectoryPath.appending(oldImagePath)
                            print(imagePath)
                            try FileManager.default.removeItem(atPath: imagePath)
                        } catch let error as NSError {
                            print(error.debugDescription)
                        }
                    }
                    
                    deleteRecipe(recipeID: self.cellID)
                    print("Delete item from database!")
                
                    self.redrawTable()
                
                }))
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ResultsTableViewCell
        
        cellID = currentCell.id as Int64
        
        recipeDetails = getRecipeDetails(recipeID: cellID)
        
        if (recipeDetails.recipeID == -1) {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Data corrupted and recipe could not be found. Delete and recreate recipe.", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        } else {
            recipeIngredients = getIngredientsByRecipe(recipeID: cellID)

            performSegue(withIdentifier: "viewDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
    
        if (segue.identifier == "viewDetails") {
            // initialize new view controller and cast it as your view controller
            let recipeVC = segue.destination as! RecipeViewController
            // your new view controller should have property that will store passed value
            recipeVC.recipeDetails = recipeDetails
            recipeVC.ingredientsArray = recipeIngredients
            recipeVC.id = cellID
            recipeVC.observer = self
        }
        
        if (segue.identifier == "addRecipe") {
            let addVC = segue.destination as! AddRecipeViewController
            addVC.resultsObserver = self
            addVC.category = group
        }
    }
    
    // MARK: Search Bar Configuration
    func filterContentForSearchText(searchText: String, scope: String) {
        
        // Filter the array using the filter method
        if self.resultsPassed.isEmpty {
            self.filteredResults = []
            return
        }
        self.filteredResults = self.resultsPassed.filter({( anItem: RecipeItem) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else if (scope == Constants.scopeName) {
                return anItem.title.lowercased().contains(searchText.lowercased())
            } else if (scope == Constants.scopeGroup) {
                return (anItem.primary.lowercased().contains(searchText.lowercased()) || anItem.secondary.lowercased().contains(searchText.lowercased()) || anItem.tertiary.lowercased().contains(searchText.lowercased()))
            } else if (scope == Constants.scopeGreaterCookTime) {
                if let value = Double(searchText) {
                    return (anItem.cookTime > value)
                } else {
                    return false
                }
            } else if (scope == Constants.scopeLesserCookTime) {
                if let value = Double(searchText) {
                    return (anItem.cookTime < value)
                } else {
                    return false
                }
            } else {
                return true
            }
        })
        
        resultsTable.reloadData()
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

extension ResultsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ResultsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
