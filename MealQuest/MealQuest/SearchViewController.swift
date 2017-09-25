//
//  SearchViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var favoriteRecipesButton: UIBarButtonItem!
    @IBOutlet weak var searchWPantryButton: UIButton!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var randomRecipeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let categoryPickerview = UIPickerView()
    var category = String()
    
    var searchResults = [RecipeItem]()
    var recipeDetails = RecipeItem(id: -1)
    var recipeIngredients = [RecipeIngredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        self.hideKeyboardWhenTappedAround()
        
        categoryPickerview.delegate = self
        categoryTextField.inputView = categoryPickerview
        categoryTextField.text = Constants.RecipeAll
        category = categoryTextField.text!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.recipeGroups.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.recipeGroups[row + 1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Constants.recipeGroups[row + 1]
        category = categoryTextField.text!
    }
    
    @IBAction func searchRecipesAction(_ sender: Any) {
        let query = self.searchTextField.text
        print("make call to search with search text: " + query!)
        // Need to parse the query
        var queryArray = query!.components(separatedBy: CharacterSet.whitespaces)
        var tempText = String()
        if (queryArray.count > 1) {
            for i in 0...(queryArray.count - 2) {
                tempText = queryArray[i]
                queryArray[i] = tempText.substring(to: tempText.index(before: tempText.endIndex))
            }
        }
        
        let category = self.categoryTextField.text
        print("make call to search with category: " + category!)
        
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        // make search on recipes with query and category ->
        searchResults = searchRecipes(query: queryArray, category: category!)
        
        performSegue(withIdentifier: "searchRecipes", sender: self)
    }
    
    @IBAction func randomRecipeAction(_ sender: Any) {
        print("select a random recipe from the DB favorites")
        
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        recipeDetails = getRandomRecipe(category: category)
        let recipeID = recipeDetails.recipeID
        recipeIngredients = getIngredientsByRecipe(recipeID: recipeID)
        
        performSegue(withIdentifier: "viewDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewDetails") {
            // initialize new view controller and cast it as your view controller
            let recipeVC = segue.destination as! RecipeViewController
            // your new view controller should have property that will store passed value
            recipeVC.recipeDetails = recipeDetails
            recipeVC.ingredientsArray = recipeIngredients
            recipeVC.random = true
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
        } else if (segue.identifier == "searchWPantry") {
            
            print("attempting to segue to search w/ pantry")
            let searchVC = segue.destination as! SearchWPantryTableViewController
            searchVC.category = category
            
        } else if (segue.identifier == "searchRecipes") {
            print("attempting to segue on search")
            
            let resultsVC = segue.destination as! ResultsTableViewController
            // To use this properly, change the stringPassed variable in ResultsViewController to dictionary structure
            resultsVC.resultsPassed = searchResults
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        
    }

}
