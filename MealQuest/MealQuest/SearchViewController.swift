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
    
    var testDict = [[String:Any]]()
    var detailsPassed = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        self.hideKeyboardWhenTappedAround()
        
        categoryPickerview.delegate = self
        categoryTextField.inputView = categoryPickerview
        categoryTextField.text = Constants.RecipeAll
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
    }
    
    @IBAction func searchRecipesAction(_ sender: Any) {
        let query = self.searchTextField.text
        print("make call to search with search text: " + query!)
        
        let category = self.categoryTextField.text
        print("make call to search with category: " + category!)
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Sorry. Search functionality is not yet ready.", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
//**    make search on recipes with query and category -> searchRecipes(query: [String], category: String) -> [RecipeItem]
        
    }
    
    @IBAction func randomRecipeAction(_ sender: Any) {
        print("select a random recipe from the DB favorites")
        
        let category = self.categoryTextField.text
        print("make call to search with category: " + category!)
        
//**    detailsPassed = getRandomRecipe(category: String) -> RecipeItem
        
        if (detailsPassed.isEmpty) {
            //1. Create the alert controller.
            var alert = UIAlertController()
            alert = UIAlertController(title: "Warning", message: "No recipes were found in favorites to be selected. Please add recipes to your favorites before trying again.", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "viewDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewDetails") {
            // initialize new view controller and cast it as your view controller
            let recipeVC = segue.destination as! RecipeViewController
            // your new view controller should have property that will store passed value
            
            recipeVC.random = true
        } else if (segue.identifier == "viewFavorites") {
            
            print("attempting to segue")
            // initialize new view controller and cast it as your view controller
            // let favoriteVC = segue.destination as! FavoriteRecipesViewController
        }

    }

}
