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

// resultSize is the number of results that are returned to the user
let resultSize: Int = 10

enum recipeData {
    case servings
    case readyInMinutes
    case preparationMinutes
    case cookingMinutes
}

// TODO: remove unnecessary recipe fields
func addNewRecipeToDB(_ recipeDict: [String:Any]) {
    let id = Date().toMillis() * (-1)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "title", data: recipeDict["title"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "calorie", data: recipeDict["calorie"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "servings", data: recipeDict["servings"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "imageURL", data: "")
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "readyInMinutes", data: recipeDict["readyInMinutes"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "preparationMinutes", data: recipeDict["preparationMinutes"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "cookingMinutes", data: recipeDict["cookingMinutes"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "healthScore", data: recipeDict["healthScore"] as! String)
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "ingredients", data: recipeDict["ingredients"] as! String )
    _ = SQLiteDB.instance.storeRecipeToDB(recipeID: id , field: "analyzedInstructions", data: recipeDict["analyzedInstructions"] as! String )
    _ = SQLiteDB.instance.addRecipeToFavouriteDB(recipeID: id)
}

// TODO: same as above
func updateRecipeInDB(_ recipeDict: [String:Any]) {
    let id = recipeDict["id"] as! Int64
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "title", data: recipeDict["title"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "calorie", data: recipeDict["calorie"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "servings", data: recipeDict["servings"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "imageURL", data: recipeDict["imageURL"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "readyInMinutes", data: recipeDict["readyInMinutes"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "preparationMinutes", data: recipeDict["preparationMinutes"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "cookingMinutes", data: recipeDict["cookingMinutes"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "healthScore", data: recipeDict["healthScore"] as! String)
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "ingredients", data: recipeDict["ingredients"] as! String )
    _ = SQLiteDB.instance.updateRecipeInDB(recipeID: id , field: "analyzedInstructions", data: recipeDict["analyzedInstructions"] as! String )
}

func getRandomRecipe() -> [String: Any] {
    
    let recipeIDList = SQLiteDB.instance.getFavouriteRecipeFieldFromDB()
    
    let randomIndex = Int(arc4random_uniform(UInt32(recipeIDList.count)))
    
    if(recipeIDList.count == 0) {
        let returnDict = [String: Any]()
        return returnDict
    } else {
        var returnDict = [String: Any]()
        returnDict = SQLiteDB.instance.getRecipeFieldFromDB(recipeID: recipeIDList[randomIndex])
        print(randomIndex)
        returnDict["id"] = recipeIDList[randomIndex]
        return returnDict
    }
}


func isFavorite(_ recipeID: Int64) -> Bool {
    let recipeIDList = SQLiteDB.instance.getFavouriteRecipeFieldFromDB()
    
    if recipeIDList.contains(recipeID) {
        return true
    } else {
        return false
    }
    
}

func getFavoriteRecipes( ) -> [[String: Any]] {
    
    var searchResults = [[String: Any]]()
    
    let recipeIDList = SQLiteDB.instance.getFavouriteRecipeFieldFromDB() 
    
    for id in recipeIDList {
        let recipeDict = SQLiteDB.instance.getRecipeFieldFromDB(recipeID: id) as [String:Any]
        
        var recipeOverview  = [String: Any]()
        recipeOverview["id"]  = id
        recipeOverview["title"]     = recipeDict["title"]       as! String
        recipeOverview["calorie"]   = recipeDict["calorie"]    as! String
        recipeOverview["imageURL"]  = recipeDict["imageURL"]       as! String
        
        searchResults.append(recipeOverview)
    }

    return searchResults.sorted{(($0)["title"] as! String).lowercased() < (($1)["title"] as! String).lowercased()}
}

// param
func searchRecipes(_ ingredients: String,_ searchCallBack: @escaping ([[String: Any]]) -> Void) {
    // TODO
}

func sendMissingIngredientsToShoppingCart(_ recipeID: Int64) {
    
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
}

func consumePantryItemsFromRecipe(_ recipeID: Int64, _ multiplier :Double) {
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
    
    var groups = ["Fruits and Veggies" : Double(0),"Wheat and Bakery" : Double(0), "Dairy" : Double(0), "Proteins" : Double(0), "Other Grocery" : Double(0)]
    
    for ingredient in ingredientsArray {
        let amountVal = Double(ingredient["amount"]!)!
        let unit = ingredient["unit"]!
        let name = ingredient["ingredient"]!

        let pantryItems = SQLiteDB.instance.getPantryItemsByName(itemName: name)
        var amountLeft = amountVal
        if(pantryItems.count > 0) {
            let groupName = (pantryItems.first!).group
            groups[groupName]! += convertToServing(amountVal, unit, groupName)
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
}







