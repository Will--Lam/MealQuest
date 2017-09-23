//
//  RecipeCategoryTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-22.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class RecipeCategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var recipeCategoryTable: UITableView!

    var categorySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Constants.recipeSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Constants.recipeSectionMap[Constants.recipeSections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < Constants.recipeSections.count {
            return Constants.recipeSections[section]
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCategoryTableViewCell", for: indexPath) as! RecipeCategoryTableViewCell

        let category = Constants.recipeSectionMap[Constants.recipeSections[indexPath.section]]?[indexPath.item]
        cell.recipeCategoryName.text = category
        cell.recipeCategoryIcon.image = UIImage(named: Constants.recipeIconMap[category!]!)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! RecipeCategoryTableViewCell
        
        categorySelected = currentCell.recipeCategoryName.text!
    
        performSegue(withIdentifier: "viewCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewCategory") {
            // initialize new view controller and cast it as your view controller
            let categoryVC = segue.destination as! ResultsTableViewController
//**    Get recipes based on a category - getRecipes(category: String) -> [RecipeItem]
            categoryVC.group = categorySelected
        } else if (segue.identifier == "addItem") {
            // initialize new view controller and cast it as your view controller
            let addVC = segue.destination as! AddRecipeViewController
            addVC.categoryObserver = self
        }
    }
    
}
