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
        tertiary:       recipeItem.tertiary,
        imagePath:      recipeItem.imagePath)!
}

func updateRecipe(recipeItem: RecipeItem) {
    _ = SQLiteDB.instance.updateRecipe(
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
        tertiary:       recipeItem.tertiary,
        imagePath:      recipeItem.imagePath)!
}

func updateRecipeIngredients(recipeID: Int64, ingredients: [Int: RecipeIngredient]) -> Int64 {
    for ingredient in SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID) {
        _ = SQLiteDB.instance.deleteIngredient(
            ingredientID: ingredient.ingredientID)
    }
    for i in 0...(ingredients.count - 1) {
        _ = SQLiteDB.instance.insertIngredient(
            recipeID:       recipeID,
            name:           (ingredients[i]?.name)!,
            unit:           (ingredients[i]?.unit)!,
            quantity:       (ingredients[i]?.quantity)!)
    }
    return recipeID
}

func deleteRecipe(recipeID: Int64) {
    _ = SQLiteDB.instance.deleteRecipe(id: recipeID)
}

func getRecipeDetails(recipeID: Int64) -> RecipeItem {
    let recipe = RecipeItem(id: -1)
    let temp = SQLiteDB.instance.getRecipeByID(id: recipeID)
    
    if (temp != nil) {
        return temp!
    } else {
        return recipe
    }
}

func getRecipes(category: String) -> [RecipeItem] {
    var recipes = [RecipeItem]()
    
    if (category == Constants.RecipeAll) {
        for recipeID in SQLiteDB.instance.getAllRecipes() {
            recipes.append(SQLiteDB.instance.getRecipeByID(id: recipeID)!)
        }
    } else {
        for recipeID in SQLiteDB.instance.getRecipeIDsByCategory(category: category) {
            recipes.append(SQLiteDB.instance.getRecipeByID(id: recipeID)!)
        }
    }
    
    recipes.sort(by: sortByTitle(this:that:))
    
    return recipes
}

func getIngredientsByRecipe(recipeID: Int64) -> [RecipeIngredient] {
    return SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID)
}

func getRandomRecipe(category: String) -> RecipeItem {
    var recipe = RecipeItem(id: -1)
    var recipeIDs = [Int64]()
    if (category == Constants.RecipeAll) {
        recipeIDs = SQLiteDB.instance.getAllRecipes()
    } else {
        recipeIDs = SQLiteDB.instance.getRecipeIDsByCategory(category: category)
    }
    let randomIndex = Int(arc4random_uniform(UInt32(recipeIDs.count)))
    if(recipeIDs.count != 0) {
        recipe = SQLiteDB.instance.getRecipeByID(id: recipeIDs[randomIndex])!
    }

    return recipe
}

func searchRecipes(query: [String], category: String) -> [RecipeItem] {
    var recipes = [RecipeItem]()
    var recipeIDs = [Int64]()
    if (category == Constants.RecipeAll) {
        recipeIDs = SQLiteDB.instance.getAllRecipes()
    } else {
        recipeIDs = SQLiteDB.instance.getRecipeIDsByCategory(category: category)
    }
    var results = [Int64:Int]()
    
    for id in recipeIDs {
        results[id] = 0
    }
    
    // case insensitive comparison
    for searchString in query {
        let recipeIDsFromIngredientsTable = SQLiteDB.instance.getRecipeIDByIngredient(ingredient: searchString)
        let commonRecipeIDs = recipeIDsFromIngredientsTable.filter{ recipeIDs.contains($0) }
        for id in commonRecipeIDs {
                results[id]! += 1
        }
    }
    
    for recipe in results {
        if (recipe.value >=  Int(ceil(Double(results.count / 2)))) {
            recipes.append(SQLiteDB.instance.getRecipeByID(id: recipe.key)!)
        }
    }
    
    recipes.sort(by: sortByTitle(this:that:))
    
    return recipes
}

func searchWPantryRecipes(category: String) -> [RecipeItem] {
    var recipes = [RecipeItem]()
    
    var searchQuery = [String]()
    
    // Get pantry items marked for search
    let pantrySearchItems = SQLiteDB.instance.getSearchPantryItems()
    
    for pantryItem in pantrySearchItems {
        searchQuery.append(pantryItem.name)
    }
    
    let recipeSearchResult = searchRecipes(query: searchQuery, category: category)
    
    for recipe in recipeSearchResult {
        recipes.append(recipe)
    }
    
    // Reset search flags in pantry
    _ = SQLiteDB.instance.revertSearchPantryItems()
    
    recipes.sort(by: sortByTitle(this:that:))
    
    return recipes
}


// TODO
func sendMissingIngredientsToShoppingCart(_ recipeID: Int64) {
    
    let recipeIngredients = SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID)
    
    var activeListID = SQLiteDB.instance.getActiveListID()
    let date = Date()
    
    if(activeListID == 0) {
        _ = SQLiteDB.instance.insertNewList(listCost: 0, listDate: date, isActive: true)
        activeListID = SQLiteDB.instance.getActiveListID()
    }
    
    for ingredientItem in recipeIngredients {
        var amountVal = ingredientItem.quantity
        
        let pantryItems = SQLiteDB.instance.getPantryItemsByName(itemName: ingredientItem.name)
        var aggregateQuantity = 0.0
        for item in pantryItems {
            aggregateQuantity += convert(item.quantity, item.unit, ingredientItem.unit)
            // round to 5 decimal places to ensure proper double subtraction
            amountVal = amountVal.roundTo(places: Constants.roundingPlaces) - aggregateQuantity.roundTo(places: Constants.roundingPlaces)
        }
        
        if(amountVal > 0) {
            let relevantItem = SQLiteDB.instance.getShoppingItemByName(listID: activeListID!, name: ingredientItem.name)
            
            if(relevantItem.listID == -1) {
                var itemGroup = Constants.PantryOther
                for item in pantryItems {
                    if(item.group != "") {
                        itemGroup = item.group
                    }
                }
                _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: ingredientItem.name, itemCost: 0, unit: ingredientItem.unit, quantity: amountVal, group: itemGroup, purchased: false, expirationDate: date, repurchase: false)
            } else {
                let shoppingQuantity = relevantItem.quantity + convert(amountVal, ingredientItem.unit, relevantItem.unit)
                _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: relevantItem.id, itemName: relevantItem.name, itemCost: 0, unit: relevantItem.unit, quantity: shoppingQuantity, group: relevantItem.group, purchased: relevantItem.purchased, expirationDate: relevantItem.expirationDate, repurchase: relevantItem.repurchase)
            }
        }
    }
}


//TODO
func consumePantryItemsFromRecipe(_ recipeID: Int64, _ multiplier :Double) {
    
    let recipeIngredients = SQLiteDB.instance.getIngredientsByRecipeID(recipeID: recipeID)
    
    for ingredient in recipeIngredients {
        
        let pantryItems = SQLiteDB.instance.getPantryItemsByName(itemName: ingredient.name)
        
        var amountLeft = ingredient.quantity * multiplier
        
        for item in pantryItems {
            let itemAmount = convert(item.quantity, item.unit, ingredient.unit)
            
            // round to 5 decimal places to ensure proper double subtraction
            amountLeft = amountLeft.roundTo(places: Constants.roundingPlaces) - itemAmount.roundTo(places: Constants.roundingPlaces)

            if (amountLeft >= 0.0) {
                _ = SQLiteDB.instance.archivePantryItem(pantryId: item.id)
            } else {
                let newAmount = (-1) * amountLeft
                _ = SQLiteDB.instance.updatePantryItem(pantryId: item.id, name: item.name, group: item.group, quantity: newAmount, unit: item.unit, calories: item.calories, expiration: item.expiration, purchase: item.purchase, archive: item.archive)
            }
        }
    }
}







