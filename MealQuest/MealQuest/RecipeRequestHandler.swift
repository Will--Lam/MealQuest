//
//  RecipeRequestHandler.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

func createRecipe(recipeItem: RecipeItem) -> Int64 {
    return SQLiteDB.instance.insertRecipe(
        title:          recipeItem.title,
        calories:       recipeItem.calories,
        servings:       recipeItem.servings,
        readyTime:      recipeItem.readyTime,
        prepTime:       recipeItem.prepTime,
        cookTime:       recipeItem.cookTime,
        instructions:   recipeItem.instructions,
        primary:        recipeItem.primary,
        secondary:      recipeItem.secondary,
        tertiary:       recipeItem.tertiary)!
}

func updateRecipe(recipeItem: RecipeItem) -> Int64 {
    return SQLiteDB.instance.updateRecipe(
        id: recipeItem.recipeID,
        title:          recipeItem.title,
        calories:       recipeItem.calories,
        servings:       recipeItem.servings,
        readyTime:      recipeItem.readyTime,
        prepTime:       recipeItem.prepTime,
        cookTime:       recipeItem.cookTime,
        instructions:   recipeItem.instructions,
        primary:        recipeItem.primary,
        secondary:      recipeItem.secondary,
        tertiary:       recipeItem.tertiary)!
}

func updateRecipeIngredients(recipeID: Int64, ingredients: [RecipeIngredient]) -> Int64 {
    for ingredient in SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID) {
        _ = SQLiteDB.instance.deleteIngredient(
            ingredientID: ingredient.ingredientID)
    }
    for iItem in ingredients {
        _ = SQLiteDB.instance.insertIngredient(
            recipeID:       recipeID,
            name:           iItem.name,
            unit:           iItem.unit,
            quantity:       iItem.quantity)
    }
    return recipeID
}

func getRecipes(category: String) -> [RecipeItem] {
    var recipes = [RecipeItem]()
    for recipeID in SQLiteDB.instance.getRecipeIDsByCategory(category: category) {
        recipes.append(SQLiteDB.instance.getRecipeByID(id: recipeID))
    }
    
    return Array(recipes)
}

func getIngredientsByRecipe(recipeID: Int64) -> [RecipeIngredient] {
    return SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID)
}

func getRandomRecipe(category: String) -> RecipeItem {
    var recipe = RecipeItem(id: -1)
    var recipeID = SQLiteDB.instance.getRecipeIDsByCategory(category: category)
    let randomIndex = Int(arc4random_uniform(UInt32(recipeID.count)))
    if(recipeID.count != 0) {
        recipe = SQLiteDB.instance.getRecipeByID(id: recipeID[randomIndex])
    }

    return recipe
}

func searchRecipes(query: [String], category: String) -> [RecipeItem] {
    var recipes = [RecipeItem]()
    let recipeIDs = SQLiteDB.instance.getRecipeIDsByCategory(category: category)
    
    var results = [Int64:Int]()
    
    for id in recipeIDs {
        results[id] = 0
    }
    
    // case insensitive comparison
    for searchString in query {
        for id in SQLiteDB.instance.getRecipeIDByIngredient(ingredient: searchString) {
            results[id]! += 1
        }
    }
    
    for recipe in results {
        if (recipe.value >=  Int(ceil(Double(results.count / 2)))) {
            recipes.append(SQLiteDB.instance.getRecipeByID(id: recipe.key))
        }
    }
    
    return recipes
}

func searchWPantryRecipes(query: [String], category: String) -> [RecipeItem] {
    let recipes = [RecipeItem]()
    
    return recipes
}


// TODO
func sendMissingIngredientsToShoppingCart(_ recipeID: Int64) {
    /*
    let recipeDict = SQLiteDB.instance.getRecipeFieldFromDB(recipeID: recipeID) as [String:Any]
    let ingredients = recipeDict["ingredients"] as! String
    var ingredientsArray = [[String:String]]()
    
    let tempArray = ingredients.components(separatedBy: "@")
    for ingredient in tempArray {
        var item = ingredient.components(separatedBy: "|")
        var tempDict = [String:String]()
        tempDict = [
            "amount": item[0],
            "unit": item[1],
            "ingredient": item[2]
        ]
        ingredientsArray.append(tempDict)
    }
    let date = Date()
    
    var activeListID = SQLiteDB.instance.getActiveListID()
    if(activeListID == 0) {
        _ = SQLiteDB.instance.insertNewList(listCost: 0, listDate: date, isActive: true)
        activeListID = SQLiteDB.instance.getActiveListID()
    }
    for ingredient in ingredientsArray {
        var amountVal = Double(ingredient["amount"]!)!
        let unit = ingredient["unit"]!
        let name = ingredient["ingredient"]!
        // TODO: Check pantry item for quantity -> use converter -> subtract & round for remaining quantity
        let pantryItems = SQLiteDB.instance.getPantryItemsByName(itemName: name)
        //let pantryItems = [PantryItem]()
        var aggregateQuantity = 0.0
        for item in pantryItems {
            aggregateQuantity += convert(item.quantity, item.unit, unit)
            
        }
        // round to 5 decimal places to ensure proper double subtraction
        amountVal = amountVal.roundTo(places: Constants.roundingPlaces) - aggregateQuantity.roundTo(places: Constants.roundingPlaces)
        if(amountVal > 0) {
            let relevantItem = SQLiteDB.instance.getShoppingItemByName(listID: activeListID!, name: name.lowercased())
            
            if(relevantItem.listID == -1) {
                var itemGroup = Constants.pantryGroups[4]
                for item in pantryItems {
                    if(item.group != "") {
                        itemGroup = item.group
                    }
                }
                _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: name, itemCost: 0, unit: unit, quantity: amountVal, group: itemGroup, purchased: false, expirationDate: date, repurchase: false)
            } else {
                let shoppingQuantity = relevantItem.quantity + convert(amountVal, unit, relevantItem.unit)
                _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: relevantItem.id, itemName: relevantItem.name, itemCost: 0, unit: relevantItem.unit, quantity: shoppingQuantity, group: relevantItem.group, purchased: relevantItem.purchased, expirationDate: relevantItem.expirationDate, repurchase: relevantItem.repurchase)
            }
        }
    }
    */
}


//TODO
func consumePantryItemsFromRecipe(_ recipeID: Int64, _ multiplier :Double) {
    /*
    let recipeDict = SQLiteDB.instance.getRecipeFieldFromDB(recipeID: recipeID) as [String:Any]
    let ingredients = recipeDict["ingredients"] as! String
    var ingredientsArray = [[String:String]]()
    
    let tempArray = ingredients.components(separatedBy: "@")
    for ingredient in tempArray {
        var item = ingredient.components(separatedBy: "|")
        var tempDict = [String:String]()
        tempDict = [
            "amount": item[0],
            "unit": item[1],
            "ingredient": item[2]
        ]
        ingredientsArray.append(tempDict)
    }
    
    for ingredient in ingredientsArray {
        let amountVal = Double(ingredient["amount"]!)!
        let unit = ingredient["unit"]!
        let name = ingredient["ingredient"]!

        let pantryItems = SQLiteDB.instance.getPantryItemsByName(itemName: name)
        var amountLeft = amountVal
        if(pantryItems.count > 0) {
//**            Need to re-evaluate how to decrement ingredients from recipe creation
        }
        // while amountLeft is positive, keep deleting pantry items
        for item in pantryItems {
            let itemAmount = convert(item.quantity, item.unit, unit)
            print("item amount")
            print(itemAmount)
            
            // round to 5 decimal places to ensure proper double subtraction
            amountLeft = amountLeft.roundTo(places: Constants.roundingPlaces) - itemAmount.roundTo(places: Constants.roundingPlaces)
            
            // delete item and break
            if (amountLeft <= 0.0) {
                if (amountLeft == 0.0) {
                    _ = SQLiteDB.instance.archivePantryItem(pantryId: item.id)
                } else {
                    let updateAmount = -1 * amountLeft
                    print(updateAmount)
                    _ = SQLiteDB.instance.updatePantryItem(pantryId: item.id, name: item.name, group: item.group, quantity: updateAmount, unit: item.unit, calories: item.calories, expiration: item.expiration.datatypeValue, purchase: item.purchase.datatypeValue, archive: item.archive.datatypeValue)
                    
                }
                
                break
            }
            
            // just archive item
            _ = SQLiteDB.instance.archivePantryItem(pantryId: item.id)
        }
    }
    // Kushal's function with recipeDict[title], recipeDict[calorie], recipeDict[servingsize], plus 4 group amount
    // multiplier for individual groups
    // let specifiedServing = Double(recipeDict["servings"] as! String)! * multiplier
    // addRecipeFoodItem(name: recipeDict["title"] as! String, calories: Double(recipeDict["calorie"] as! String)! * specifiedServing, proteins: groups["Proteins"]! * multiplier, vegetables: groups["Fruits and Veggies"]! * multiplier, dairy: groups["Dairy"]! * multiplier, grains: groups["Wheat and Bakery"]! * multiplier, servings: specifiedServing)
    */
 */
}







