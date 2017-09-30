//
//  RecipeButtonExtension.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

extension RecipeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        if (segue.identifier == "editDetails") {
            // initialize new view controller and cast it as your view controller
            let editVC = segue.destination as! AddRecipeViewController
            // your new view controller should have property that will store passed value
            editVC.edit = true
            editVC.recipeDetails = recipeDetails
            editVC.recipeIngredients = ingredientsArray
            editVC.id = id
            editVC.recipeObserver = self
        }
    }
    
    @IBAction func planAction(_ sender: Any) {
        var response = -1
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm adding missing ingredients based on pantry to shopping list?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
//**        Add response in response from send missing ingredients to shopping cart
            sendMissingIngredientsToShoppingCart(self.id)
            response = 1
            
            if (response != -1) {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Missing ingredients have been added to the active shopping list.", message: "", preferredStyle: .alert)
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }

        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func eatAction(_ sender: Any) {
        var response = -1
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm cooking and eating the meal?", message: "The corresponding ingredients will be removed from the pantry, prioritizing expiring items. \n\n Please enter the amount of servings created.", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            // TODO: add place holder text
            textField.keyboardType = .decimalPad
            textField.placeholder = "\(self.servingSize)"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if (textField?.text == "") {
                textField?.text = textField?.placeholder
            }
            print("Text field: \(String(describing: textField!.text))")
            
            let servingMultiplier = Double(Double(textField!.text!)!/Double(self.servingSize))
            
//**        Add in response from consumePantryItems
            consumePantryItemsFromRecipe(self.id, servingMultiplier)
            response = 1
            
            if (response != -1) {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Pantry items have been removed from the pantry.", message: "", preferredStyle: .alert)
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
