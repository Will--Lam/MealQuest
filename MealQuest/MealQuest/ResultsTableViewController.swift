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
    var detailsPassed = RecipeItem(id: -1)
    var cellID = Int64()
    var group = "Search Results"
    
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var addRecipeButton: UIButton!
    
    func redrawTable( ) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redrawTable()
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
        
        // Configure the cell...
        print("idVal is: " + "\(idVal)")
        cell.id = idVal
        cell.titleLabel.text = titleText
        cell.calorieLabel.text = "\(calorieVal)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ResultsTableViewCell
        
        cellID = currentCell.id as Int64
        
        if (cellID != -1) {
            print("id is: " + "\(cellID)")
//**        get ingredients information based on recipeID - getIngredientsByRecipe(recipeID: Int64) -> [RecipeIngredient]
        } else {
            
        }

        performSegue(withIdentifier: "viewDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
    
        if (segue.identifier == "viewDetails") {
            // initialize new view controller and cast it as your view controller
            let recipeVC = segue.destination as! RecipeViewController
            // your new view controller should have property that will store passed value
            recipeVC.recipeDetails = detailsPassed
            recipeVC.id = cellID
            recipeVC.observer = self
        }
        
        if (segue.identifier == "addRecipe") {
            let addVC = segue.destination as! AddRecipeViewController
            addVC.resultsObserver = self
        }
    }

}
