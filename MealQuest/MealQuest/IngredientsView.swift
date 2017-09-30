//
//  IngredientsView.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-11.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class IngredientsView: UIView {

    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var changeServingButton: UIButton!
    @IBOutlet weak var changeServingLabel: UILabel!
    
    var servingSize = Double()
    var newServingSize = Double()
    var observer: RecipeViewController!
    var ingredientsArray = [RecipeIngredient]()
    
    func redrawTable( ) {
        updateIngredients()
        servingSize = newServingSize
        observer.recipeDetails.servings = servingSize
        observer.redrawView()
    }
    
    func updateIngredients( ) {
        let servingMultiplier = Double(Double(newServingSize)/Double(servingSize))
        for (index, _) in ingredientsArray.enumerated() {
            ingredientsArray[index].quantity = ingredientsArray[index].quantity * servingMultiplier
        }
        
        observer.ingredientsArray = ingredientsArray
        
        var allIngredients = [Int: RecipeIngredient]()
        for i in 0...(ingredientsArray.count - 1) {
            allIngredients[i] = ingredientsArray[i]
        }
        
        _ = updateRecipeIngredients(recipeID: observer.recipeDetails.recipeID, ingredients: allIngredients)
    }
    
    @IBAction func changedServing(sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Change serving size", message: "Enter a new serving size and ingredients will be adjusted accordingly.", preferredStyle: .alert)
        
        //2. Add the text field.
        alert.addTextField { (textField) in
            let textFieldText = String(self.servingSize)
            textField.placeholder = textFieldText
            textField.keyboardType = .numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if (!textField!.text!.isEmpty) {
                self.observer.recipeDetails.servings = Double(textField!.text!)!
                updateRecipe(recipeItem: self.observer.recipeDetails)
                self.redrawTable()
            }
        }))
        
        // Present the alert.
        observer.present(alert, animated: true, completion: nil)
    }

}
