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
    
    var servingSize = Int()
    var newServingSize = Int()
    var observer: RecipeViewController!
    var ingredientsArray = [[String:String]]()
    
    func redrawTable( ) {
        updateIngredients()
        servingSize = newServingSize
        // observer.recipeDetails["servings"] = "\(servingSize)"
        observer.redrawView()
    }
    
    func updateIngredients( ) {
        let servingMultiplier = Double(Double(newServingSize)/Double(servingSize))
        for (index, _) in ingredientsArray.enumerated() {
            ingredientsArray[index]["amount"] = (Double(ingredientsArray[index]["amount"]!)! * servingMultiplier).formatString(places: 2)
        }
        
        var ingredients = String()
        for item in ingredientsArray {
            let amount = item["amount"]!
            let unit = item["unit"]!
            let ingredient = item["ingredient"]!
            ingredients += amount + "|" + unit + "|" + ingredient + "@"
        }
        
        ingredients.remove(at: ingredients.index(before: ingredients.endIndex))
        
        // observer.recipeDetails["ingredients"] = ingredients
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
                self.newServingSize = Int(textField!.text!)!
                self.redrawTable()
            }
        }))
        
        // Present the alert.
        observer.present(alert, animated: true, completion: nil)
    }

}
