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

class AddRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var servingSizeField: UITextField!
    @IBOutlet weak var readyTimeField: UITextField!
    @IBOutlet weak var prepTimeField: UITextField!
    @IBOutlet weak var totalTimeField: UITextField!
    @IBOutlet weak var primaryCategoryField: UITextField!
    var primary = String()
    @IBOutlet weak var secondaryCategoryField: UITextField!
    var secondary = String()
    @IBOutlet weak var tertiaryCategoryField: UITextField!
    var tertiary = String()
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var saveFavorite: UIButton!
    
    let primaryPickerView = UIPickerView()
    let secondaryPickerView = UIPickerView()
    let tertiaryPickerView = UIPickerView()
    let recipeOptions = Constants.recipeGroups.filter { $0 != Constants.RecipeAll}
    
    var edit = false
    var category = ""
    var recipeDetails = RecipeItem(id: -1)
    var recipeIngredients = [RecipeIngredient]()
    var id = Int64(-1)
    var addFromCategory = false
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
        
        primaryPickerView.delegate = self
        primaryPickerView.tag = 1
        primaryCategoryField.inputView = primaryPickerView
        if (category != "") {
            primaryCategoryField.text = category
        } else {
            primaryCategoryField.text = Constants.RecipeBlank
        }
        
        secondaryPickerView.delegate = self
        secondaryPickerView.tag = 2
        secondaryCategoryField.inputView = secondaryPickerView
        secondaryCategoryField.text = Constants.RecipeBlank
        
        tertiaryPickerView.delegate = self
        tertiaryPickerView.tag = 3
        tertiaryCategoryField.inputView = tertiaryPickerView
        tertiaryCategoryField.text = Constants.RecipeBlank
        
        if (edit) {
            // Pre-populate all the information into the text fields.
            recipeNameField.text = recipeDetails.title
            caloriesField.text = String(recipeDetails.calories)
            servingSizeField.text = String(recipeDetails.servings)
            readyTimeField.text = String(recipeDetails.readyTime)
            totalTimeField.text = String(recipeDetails.cookTime)
            prepTimeField.text = String(recipeDetails.prepTime)
            primaryCategoryField.text = recipeDetails.primary
            secondaryCategoryField.text = recipeDetails.secondary
            tertiaryCategoryField.text = recipeDetails.tertiary
 
            // Get the ingredients into a single displayable string
            var allIngredients = String()
            for ingredient in recipeIngredients {
                allIngredients += "\(ingredient.quantity)"  + " " + ingredient.unit + " " + ingredient.name + "\n"
            }
            ingredientsTextView.text = allIngredients
            
            // Get the instruction info into a single displayable string
            var allInstructions = String()
            let instructions = recipeDetails.instructions
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            primaryCategoryField.text = recipeOptions[row]
        } else if (pickerView.tag == 2) {
            secondaryCategoryField.text = recipeOptions[row]
        } else if (pickerView.tag == 3) {
            tertiaryCategoryField.text = recipeOptions[row]
        }
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
            let ingredientsParse = ingredientsTextView.text!.components(separatedBy: CharacterSet.newlines)
            var allIngredients = [Int: RecipeIngredient]()
            for (index,step) in ingredientsParse.enumerated() {
                print(step)
                let newIngredient = RecipeIngredient(id: -1)
                let parse = step.components(separatedBy: CharacterSet.whitespaces)
                var ingredientName = String()
                guard (parse.count > 2) else {
                    throw addRecipeError.ingredientFormat
                }
                for (index,ingredient) in parse.enumerated() {
                    if (index == 0) {
                        guard (Double(ingredient) != nil) else {
                            throw addRecipeError.ingredientAmount
                        }
                        newIngredient.quantity = Double(ingredient)!
                    } else if (index == 1) {
                        newIngredient.unit = ingredient
                    } else {
                        ingredientName += ingredient + " "
                    }
                }
                ingredientName.remove(at: ingredientName.index(before: ingredientName.endIndex))
                newIngredient.name = ingredientName
                allIngredients[index] = newIngredient
            }
            
            // Parse the instructions
            let itemArray = instructionsTextView.text!.components(separatedBy: CharacterSet.newlines)
            var allInstructions = String()
            for (index,step) in itemArray.enumerated() {
                allInstructions += "\(index + 1)" + "|" + step + "|"
            }
            allInstructions.remove(at: allInstructions.index(before: allInstructions.endIndex))
            
            // Shift categories to upmost category
            if (primaryCategoryField.text == Constants.RecipeBlank) {
                if (secondaryCategoryField.text != Constants.RecipeBlank) {
                    primaryCategoryField.text = secondaryCategoryField.text
                    if (tertiaryCategoryField.text != Constants.RecipeBlank) {
                        secondaryCategoryField.text = tertiaryCategoryField.text
                        tertiaryCategoryField.text = Constants.RecipeBlank
                    } else {
                        secondaryCategoryField.text = Constants.RecipeBlank
                    }
                } else if (tertiaryCategoryField.text != Constants.RecipeBlank) {
                    primaryCategoryField.text = tertiaryCategoryField.text
                    tertiaryCategoryField.text = Constants.RecipeBlank
                } else {
                    primaryCategoryField.text == Constants.RecipeOther
                }
            } else if (secondaryCategoryField.text == Constants.RecipeBlank) {
                if (tertiaryCategoryField.text != Constants.RecipeBlank) {
                    secondaryCategoryField.text = tertiaryCategoryField.text
                    tertiaryCategoryField.text = Constants.RecipeBlank
                }
            }
            
            var newRecipeItem = RecipeItem(id: -1)
            if (edit) {
                newRecipeItem = RecipeItem(id: self.id)
            }
            newRecipeItem.title = recipeNameField.text!
            newRecipeItem.calories = Int(caloriesField.text!)!
            newRecipeItem.servings = Double(servingSizeField.text!)!
            if (readyTimeField.text! != "") {
                newRecipeItem.readyTime = Double(readyTimeField.text!)!
            }
            if (prepTimeField.text! != "") {
                newRecipeItem.prepTime = Double(prepTimeField.text!)!
            }
            if (totalTimeField.text! != "") {
                newRecipeItem.cookTime = Double(totalTimeField.text!)!
            }
            newRecipeItem.primary = primaryCategoryField.text!
            newRecipeItem.secondary = secondaryCategoryField.text!
            newRecipeItem.tertiary = tertiaryCategoryField.text!
            newRecipeItem.instructions = allInstructions
            
            _ = updateRecipeIngredients(recipeID: newRecipeItem.recipeID, ingredients: allIngredients)
            
            // Call function to add the recipe the database
            if (edit) {
                
                _ = updateRecipe(recipeItem: newRecipeItem)
                // Need to redraw the view
                recipeObserver.redrawView()
                
            } else if (addFromCategory) {
                _ = createRecipe(recipeItem: newRecipeItem)
            } else {
                _ = createRecipe(recipeItem: newRecipeItem)
                
                resultsObserver.resultsPassed = getRecipes(category: category)
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
