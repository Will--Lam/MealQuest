//
//  RecipeViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-06.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var resultsPassed = [RecipeItem]()
    var recipeDetails = RecipeItem(id: -1)
    var recipeIngredients = [RecipeIngredient]()
    var cellID = Int64()
    var group = "Search Results"
    
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var addRecipeButton: UIButton!
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsPassed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        
        let idVal = resultsPassed[indexPath.item].recipeID 
        let titleText = resultsPassed[indexPath.item].title
        let calorieVal = resultsPassed[indexPath.item].calories
        let recipeCategory = resultsPassed[indexPath.item].primary
        
        // Configure the cell...
        cell.id = idVal
        cell.category = recipeCategory
        cell.titleLabel.text = titleText
        cell.calorieLabel.text = "\(calorieVal)"
        cell.categoryIcon.image = UIImage(named: Constants.recipeIconMap[recipeCategory]!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (group != "Search Results") {
            let currentCell = tableView.cellForRow(at: indexPath)! as! ResultsTableViewCell
        
            cellID = currentCell.id as Int64
        
            if editingStyle == .delete {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Confirm to delete the recipe?", message: "", preferredStyle: .alert)
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                
                    deleteRecipe(recipeID: self.cellID)
                    print("Delete item from database!")
                
                    self.redrawTable()
                
                }))
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
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

}
