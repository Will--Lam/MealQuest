//
//  FavoriteRecipesViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-19.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class FavoriteRecipesViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        print("retrieve favorite recipes from DB")
        
        // Make call to find all favorited recipes
        
        let recipeResults = getFavoriteRecipes( )
        let resultsVC = storyboard?.instantiateViewController(withIdentifier: "ResultsTableViewController") as! ResultsTableViewController
        // To use this properly, change the stringPassed variable in ResultsViewController to dictionary structure
        resultsVC.resultsPassed = recipeResults
        resultsVC.favoriteTable = true
        navigationController?.pushViewController(resultsVC, animated: true)
    }

}
