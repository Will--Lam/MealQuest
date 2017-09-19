//
//  FoodApi.swift
//  MealQuest
//
//  Created by Kushal Kumarasinghe on 2017-06-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation
import Alamofire


let apiKey: String = "B9MsKcC5LWmsh10MGfZQbKMe6hXzp158WJyjsnmrXFc3f4FnKz"
let baseUrl: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex?"


func getRecipes(_ ingredients: String, _ amount: Int, completionHandler: @escaping ([[String: Any]], Error?) -> ()) -> Void {

    let modifiedIngredients = ingredients.replacingOccurrences(of: " ", with: "%20")

    let params: [String: Any] = [
        "addRecipeInformation": true,
        "fillIngredients": true,
        "includeIngredients": modifiedIngredients,
        "instructionsRequired": true,
        "ranking": 1,
        "number": amount,
        "maxCarbs": 8000,
        "maxCalories": 8000,
        "maxProtein": 8000,
        "maxFat": 8000,
        ]

    var url = baseUrl
    var stringParams = [String]()

    for (key, val) in params{
        stringParams.append("\(key)=\(val)")
    }

    url += stringParams.joined(separator: "&")

    let headers: HTTPHeaders = [
        "X-Mashape-Key": apiKey,
        "Accept": "application/json"
    ]
    
    Alamofire.request(
        url,
        method: .get,
        headers: headers
        ).responseJSON { response in

            if (response.result.isSuccess) {
                var recipes = [[String: Any]]()

                if let value = response.result.value as? [String: AnyObject] {
                    let results = value["results"] as! NSArray

                    for recipeJSON in results{
                        var recipeDict = recipeJSON as! [String: Any]

                        var recipeFilterd = [String: Any]()

                        // identification
                        recipeFilterd["title"] = recipeDict["title"] as! String
                        recipeFilterd["id"] = recipeDict["id"] as! Int
                        recipeFilterd["imageURL"] = recipeDict["image"] as! String

                        // time
                        let readyInMinutesVal = recipeDict["readyInMinutes"] as! Int
                        recipeFilterd["readyInMinutes"] = "\(readyInMinutesVal)"
                        
                        if(type(of: recipeDict["preparationMinutes"]) == Int.self) {
                            let preparationMinutes = recipeDict["preparationMinutes"] as! Int
                            recipeFilterd["preparationMinutes"] = "\(preparationMinutes)"
                        } else if(type(of: recipeFilterd["preparationMinutes"]) == String.self) {
                            recipeFilterd["preparationMinutes"] = recipeDict["preparationMinutes"] as! String!
                        } else {
                            recipeFilterd["preparationMinutes"] = "N/A"
                        }
                        
                        if(type(of: recipeDict["cookingMinutes"]) == Int.self) {
                            let cookingMinutes = recipeDict["cookingMinutes"] as! Int
                            recipeFilterd["cookingMinutes"] = "\(cookingMinutes)"
                        } else if(type(of: recipeFilterd["cookingMinutes"]) == String.self) {
                            recipeFilterd["cookingMinutes"] = recipeDict["cookingMinutes"] as! String!
                        } else {
                            recipeFilterd["cookingMinutes"] = "N/A"
                        }

                        // info
                        let servingsVal = recipeDict["servings"] as! Int
                        recipeFilterd["servings"] = "\(servingsVal)"
                        let calorieVal = recipeDict["calories"] as! Int
                        recipeFilterd["calorie"] = "\(calorieVal)"
                        //recipeFilterd["carbs"] = recipeDict["carbs"] as! String
                        //recipeFilterd["fat"] = recipeDict["fat"] as! String
                        //recipeFilterd["protein"] = recipeDict["protein"] as! String
                        //recipeFilterd["missedIngredientCount"] = recipeDict["missedIngredient"] as! String
                        let healthScoreVal = recipeDict["healthScore"] as! Int
                        recipeFilterd["healthScore"] = "\(healthScoreVal)"
                        
                        let usedIngredients = filterIngredients(recipeDict["usedIngredients"]!)
                        let missedIngredients = filterIngredients(recipeDict["missedIngredients"]!)

                        recipeFilterd["usedIngredients"] = usedIngredients
                        recipeFilterd["missedIngredients"] = missedIngredients

                        recipeFilterd["ingredients"] = usedIngredients + missedIngredients

                        recipeFilterd["analyzedInstructions"] = filterInstructions(recipeDict["analyzedInstructions"]!)

                        recipes.append(recipeFilterd)
                    }

                }

                completionHandler(recipes, nil)
            }
            else {
                completionHandler([[:]], response.result.error)
            }
    }
}

func filterIngredients(_ ingredients: Any) -> [[String: Any]] {
    var filteredIngredients = [[String: Any]]()

    if let ingredientsJSON = ingredients as? [[String: AnyObject]] {

        for ingredientJSON in ingredientsJSON{
            var ingredientFilterd = [String: Any]()

            ingredientFilterd["name"] = ingredientJSON["name"] as! String
            ingredientFilterd["amount"] = ingredientJSON["amount"] as! Double
            ingredientFilterd["unit"] = ingredientJSON["unit"] as! String
            ingredientFilterd["unitLong"] = ingredientJSON["unitLong"] as! String

            ingredientFilterd["id"] = ingredientJSON["id"] as! Int

            filteredIngredients.append(ingredientFilterd)
        }
    }

    return filteredIngredients
}

func filterInstructions(_ instructions: Any) -> [[String: Any]] {
    var filteredInstructions = [[String: Any]]()

    if let instructionsJSON = instructions as? [[String: AnyObject]] {

        for instructionJSON in instructionsJSON{
            var instructionFilterd = [String: Any]()

            instructionFilterd["name"] = instructionJSON["name"] as! String

            // compute step
            var filteredSteps = [[String: Any]]()

            let stepsJSON = instructionJSON["steps"] as! [[String: Any]]

            for s in stepsJSON{
                var stepFiltered = [String:Any]()
                stepFiltered["step"] = s["step"] as! String
                stepFiltered["number"] = s["number"] as! Int


                filteredSteps.append(stepFiltered)
            }

            instructionFilterd["steps"] = filteredSteps

            filteredInstructions.append(instructionFilterd)
        }
    }

    return filteredInstructions
}
