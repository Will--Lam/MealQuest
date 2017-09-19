//
//  AddRecipeViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-03.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

enum addRecipeError: Error {
    case ingredientAmount
    case fieldMissing
    case ingredientFormat
    case fieldFormat
}

class AddRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var servingSizeField: UITextField!
    @IBOutlet weak var readyTimeField: UITextField!
    @IBOutlet weak var prepTimeField: UITextField!
    @IBOutlet weak var totalTimeField: UITextField!
    @IBOutlet weak var healthScoreField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var saveFavorite: UIButton!
    var edit = false
    var recipeDetails = [String:Any]()
    var id = Int64(-1)
    var recipeObserver = RecipeViewController()
    var resultsObserver = ResultsTableViewController()
    
    //1. Create the alert controller.
    var alert = UIAlertController()
    var msg = String()
    
    var recipeDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        if (edit) {
            // Pre-populate all the information into the text fields.
            recipeNameField.text = (recipeDetails["title"] as! String)
            caloriesField.text = (recipeDetails["calorie"] as! String)
            servingSizeField.text = (recipeDetails["servings"] as! String)
            readyTimeField.text = (recipeDetails["readyInMinutes"] as! String)
            totalTimeField.text = (recipeDetails["cookingMinutes"] as! String)
            prepTimeField.text = (recipeDetails["preparationMinutes"] as! String)
            healthScoreField.text = (recipeDetails["healthScore"] as! String)
            
            // Get the ingredients information into a single displayable string
            var allIngredients = String()
            let ingredients = recipeDetails["ingredients"] as! String
            let tempIngredients = ingredients.components(separatedBy: "@")
            for ingredient in tempIngredients {
                let item = ingredient.components(separatedBy: "|")
                allIngredients += item[0]  + " " + item[1] + " " + item[2] + "\n"
            }
            allIngredients.remove(at: allIngredients.index(before: allIngredients.endIndex))
            ingredientsTextView.text = allIngredients
            
            // Get the instruction information into a single displayable string
            var allInstructions = String()
            let instructions = recipeDetails["analyzedInstructions"] as! String
            let tempInstructions = instructions.components(separatedBy: "|")
            for (index, instruction) in tempInstructions.enumerated() {
                if((index % 2) == 1) {
                    allInstructions += instruction + "\n"
                }
            }
            allInstructions.remove(at: allInstructions.index(before: allInstructions.endIndex))
            instructionsTextView.text = allInstructions
        }
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveFavoriteAction(_ sender: Any) {
        // Check for nil values in name, calories, serving size, ingredients, instructions
        do {
            // Check mandatory fields
            guard ((recipeNameField.text! != "") && (instructionsTextView.text! != "") && (ingredientsTextView.text! != "")) else {
                    throw addRecipeError.fieldMissing
            }
            
            guard ((Double(caloriesField.text!) != nil) && (Double(servingSizeField.text!) != nil) && (Double(caloriesField.text!)! > Double(-1)) && (Double(servingSizeField.text!)! > Double(-1))) else {
                    throw addRecipeError.fieldFormat
            }
            
            // Parse the ingredients
            let ingredientsArray = ingredientsTextView.text!.components(separatedBy: CharacterSet.newlines)
            var allIngredients = String()
            for step in ingredientsArray {
                print(step)
                let parse = step.components(separatedBy: CharacterSet.whitespaces)
                guard (parse.count > 2) else {
                    throw addRecipeError.ingredientFormat
                }
                for (index,ingredient) in parse.enumerated() {
                    if (index == 0) {
                        guard (Double(ingredient) != nil) else {
                            throw addRecipeError.ingredientAmount
                        }
                        allIngredients += ingredient + "|"
                    } else if (index == 1) {
                        allIngredients += ingredient + "|"
                    } else {
                        allIngredients += ingredient + " "
                    }
                }
                allIngredients.remove(at: allIngredients.index(before: allIngredients.endIndex))
                allIngredients += "@"
            }
            allIngredients.remove(at: allIngredients.index(before: allIngredients.endIndex))
            
            // Parse the instructions
            let itemArray = instructionsTextView.text!.components(separatedBy: CharacterSet.newlines)
            var allInstructions = String()
            for (index,step) in itemArray.enumerated() {
                allInstructions += "\(index + 1)" + "|" + step + "|"
            }
            allInstructions.remove(at: allInstructions.index(before: allInstructions.endIndex))
            
            // Call function to add the recipe the database
            if (edit) {
                recipeDict = [
                    "id": self.id,
                    "imageURL": recipeDetails["imageURL"]!,
                    "title": recipeNameField.text!,
                    "calorie": caloriesField.text!,
                    "servings": servingSizeField.text!,
                    "readyInMinutes": readyTimeField.text!,
                    "preparationMinutes": prepTimeField.text!,
                    "cookingMinutes": totalTimeField.text!,
                    "healthScore": healthScoreField.text!,
                    "ingredients": allIngredients,
                    "analyzedInstructions": allInstructions
                ]
                
                updateRecipeInDB(recipeDict)
                
                // Need to redraw the view
                recipeObserver.recipeDetails = recipeDict
                recipeObserver.redrawView()
            } else {
                recipeDict = [
                    "title": recipeNameField.text!,
                    "calorie": caloriesField.text!,
                    "servings": servingSizeField.text!,
                    "readyInMinutes": readyTimeField.text!,
                    "preparationMinutes": prepTimeField.text!,
                    "cookingMinutes": totalTimeField.text!,
                    "healthScore": healthScoreField.text!,
                    "ingredients": allIngredients,
                    "analyzedInstructions": allInstructions
                ]
                
                addNewRecipeToDB(recipeDict)
                
                resultsObserver.resultsPassed = getFavoriteRecipes( )
                resultsObserver.redrawTable()
            }
            self.navigationController?.popViewController(animated: true)
        } catch addRecipeError.ingredientAmount {
            msg = "An ingredient amount is incorrect. Please check that all new lines start with a number."
        } catch addRecipeError.fieldFormat {
            msg = "The serving size or calorie field is incorrect. Please ensure they are numbers."
        } catch addRecipeError.ingredientFormat {
            msg = "Ingredient format in correct. Please follow the '# unit ingredient' format."
        } catch addRecipeError.fieldMissing {
            msg = "Required fields are missing. Please fill in values for all required fields."
        } catch {
            msg = "Unknown error has been found. Please check the form again to follow specifications."
        }
        alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}
