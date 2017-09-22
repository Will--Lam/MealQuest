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
            editVC.id = id
            editVC.recipeObserver = self
        }
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        if (!favorite) {
            print("favorite!")
            let temp = 0 // SQLiteDB.instance.addRecipeToFavouriteDB(recipeID: id)
            if (temp != 0) {
                favoriteButton.setImage(UIImage(named: "favoriteIcon.png"), for: .normal)
                favoriteButton.setTitle("  Unfavorite",for: .normal)
                favorite = true
                editButton.isHidden = false
                editButton.isEnabled = true
                overviewView.newImageButton.isHidden = false
                overviewView.newImageButton.isEnabled = true
            } else {
                //1. Create the alert controller.
                var alert = UIAlertController()
                alert = UIAlertController(title: "Error", message: "Recipe could not be favorited at this time. Try again later.", preferredStyle: .alert)
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("unfavorite!")
            let temp = 0 // SQLiteDB.instance.unmarkFavouriteRecipeDB(recipeID: id)
            if (temp != 0) {
                favoriteButton.setImage(UIImage(named: "unfavoriteIcon.png"), for: .normal)
                favoriteButton.setTitle("  Favorite",for: .normal)
                favorite = false
                editButton.isHidden = true
                editButton.isEnabled = false
                overviewView.newImageButton.isHidden = true
                overviewView.newImageButton.isEnabled = false
            } else {
                //1. Create the alert controller.
                var alert = UIAlertController()
                alert = UIAlertController(title: "Error", message: "Recipe could not be unfavorite at this time. Try again later.", preferredStyle: .alert)
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func planAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm adding these items to shopping list?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            // Call update to shopping cart
            sendMissingIngredientsToShoppingCart(self.id)
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func eatAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm cooking and eating the meal?", message: "The corresponding skills will be increased for your performance, and the calories will be added to the diary. \n\n Please enter the amount of servings created.", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            // TODO: add place holder text
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
            
//**        Need to consume proper serving amount
//            validateSkills(self.recipeDetails["analyzedInstructions"] as! String)
            
            let servingMultiplier = Double(Double(textField!.text!)!/Double(self.servingSize))
            
            // delete pantry item ingredients
            consumePantryItemsFromRecipe(self.id, servingMultiplier)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        // Send instructions of made dish to challenges
        // progressSkill(instructionsView.instructionLabel.text)
    }
}
