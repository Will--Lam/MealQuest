//
//  SQLiteDB.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-05-24.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

import SQLite

class SQLiteDB {
    static let instance = SQLiteDB()
    private let db: Connection?
    
    // Testing constants to reset databases
    private let testingConstant         = false
    private let deleteCategoryTable     = false
    private let deletePantryTable       = false
    private let deleteShoppingLists     = false
    private let deleteShoppingItem      = false
    private let deleteRecipeTable       = true      // recipe table and ingredient table tightly coupled, should treat as such, remove option to delete separately and just couple it
    private let deleteIngredientTable   = true
    
    // Recipe table
    private let recipeTable         = Table("recipes")
    private let recipeID            = Expression<Int64>("id")
    private let recipeTitle         = Expression<String>("title")
    private let recipeCalories      = Expression<Int>("calories")
    private let recipeServings      = Expression<Double>("servings")
    private let recipeReadyTime     = Expression<Double>("readyTime")
    private let recipePrepTime      = Expression<Double>("prepTime")
    private let recipeCookTime      = Expression<Double>("cookTime")
    private let recipeInstructions  = Expression<String>("instructions")
    private let recipePrimary       = Expression<String>("primary")
    private let recipeSecondary     = Expression<String>("secondary")
    private let recipeTertiary      = Expression<String>("tertiary")
    private let recipeImagePath     = Expression<String>("imagePath")
    
    // Ingredient table
    private let ingredientTable     = Table("ingredients")
    private let ingredientID        = Expression<Int64>("id")
    private let ingredientRecipeID  = Expression<Int64>("recipeID")
    private let ingredientName      = Expression<String>("name")
    private let ingredientUnit      = Expression<String>("unit")
    private let ingredientQuantity  = Expression<Double>("quantity")
    
    // Pantry items table
    private let pantryTable         = Table("pantry")
    private let pantryItemId        = Expression<Int64>("id")
    private let pantryItemName      = Expression<String>("name")
    private let pantryItemGroup     = Expression<String>("group")
    private let pantryItemQuantity  = Expression<Double>("quantity")
    private let pantryItemUnit      = Expression<String>("unit")
    private let pantryItemCalories  = Expression<Int?>("calories")
    private let pantryItemArchived  = Expression<Int>("isArchived")
    private let pantryItemToggle    = Expression<Int>("toggle")
    private let pantryItemSearch    = Expression<Int>("search")
    // dates
    private let pantryItemExpiration    = Expression<Date?>("expiration")
    private let pantryItemPurchase      = Expression<Date>("purchase")
    private let pantryItemArchive       = Expression<Date?>("archive")
    
    // Pantry Expiration Table
    private let pantryExpirationTable   = Table("pantryExpiration")
    private let pantryExpirationID      = Expression<Int64>("expirationID")
    private let pantryExpirationGroup   = Expression<String>("expirationGroup")
    private let pantryExpirationDays    = Expression<Int>("expirationDays")
    
    // Shopping Lists Table
    private let shoppingListsTable      = Table("shoppingLists")
    private let shoppingListsID         = Expression<Int64>("listID")
    private let shoppingListsCost       = Expression<Double>("listCost")
    private let shoppingListsDate       = Expression<Date>("listDate")
    private let shoppingListsIsActive   = Expression<Bool>("isActive")
    
    // Shopping Item Table
    private let shoppingItemTable           = Table("shoppingItem")
    private let shoppingItemListID          = Expression<Int64>("listID")
    private let shoppingItemID              = Expression<Int64>("itemID")
    private let shoppingItemName            = Expression<String>("itemName")
    private let shoppingItemCost            = Expression<Double>("itemCost")
    private let shoppingItemUnit            = Expression<String>("unit")
    private let shoppingItemQuantity        = Expression<Double>("quantity")
    private let shoppingItemCategory        = Expression<String>("group") // category
    private let shoppingItemPurchased       = Expression<Bool>("purchased")
    private let shoppingItemExpirationDate  = Expression<Date?>("expirationDate")
    private let shoppingItemRepurchase      = Expression<Bool>("repurchase")
    
    
    
    let dateFormatter = DateFormatter()
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            createRecipeTable()
            createIngredientTable()
            createPantryTable()
            createShoppingListsTable()
            createShoppingItemTable()
            createPantryExpirationTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    // RECIPE TABLE DIVIDER
    
    func createRecipeTable() {
        do {
            if (deleteRecipeTable) {
                try db?.run(recipeTable.drop(ifExists: true))
            }
            
            try db!.run(recipeTable.create(ifNotExists: true) { table in
                table.column(recipeID, primaryKey: true)
                table.column(recipeTitle)
                table.column(recipeCalories)
                table.column(recipeServings)
                table.column(recipeReadyTime)
                table.column(recipePrepTime)
                table.column(recipeCookTime)
                table.column(recipeInstructions)
                table.column(recipePrimary)
                table.column(recipeSecondary)
                table.column(recipeTertiary)
                table.column(recipeImagePath)
            })
            print("Recipe table created")
        } catch {
            print("Unable to create recipe table")
        }
    }
    
    func insertRecipe(title: String, calories: Int, servings: Double, readyTime: Double, prepTime: Double, cookTime: Double, instructions: String, primary: String, secondary: String, tertiary: String, imagePath: String) -> Int64? {
        do {
            let insert = recipeTable.insert(
                recipeTitle         <- title,
                recipeCalories      <- calories,
                recipeServings      <- servings,
                recipeReadyTime     <- readyTime,
                recipePrepTime      <- prepTime,
                recipeCookTime      <- cookTime,
                recipeInstructions  <- instructions,
                recipePrimary       <- primary,
                recipeSecondary     <- secondary,
                recipeTertiary      <- tertiary,
                recipeImagePath     <- imagePath)
            
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Error info: \(error)")
            print("Insert recipe failed")
            return nil
        }
    }
    
    func updateRecipe(id: Int64, title: String, calories: Int, servings: Double, readyTime: Double, prepTime: Double, cookTime: Double, instructions: String, primary: String, secondary: String, tertiary: String, imagePath: String) -> Int64? {
        do {
            let updateQuery = recipeTable.filter(
                recipeID == id)
            
            let id = try db!.run(updateQuery.update(
                recipeTitle         <- title,
                recipeCalories      <- calories,
                recipeServings      <- servings,
                recipeReadyTime     <- readyTime,
                recipePrepTime      <- prepTime,
                recipeCookTime      <- cookTime,
                recipeInstructions  <- instructions,
                recipePrimary       <- primary,
                recipeSecondary     <- secondary,
                recipeTertiary      <- tertiary,
                recipeImagePath     <- imagePath))
            
            return Int64(id)
        } catch {
            print("Update recipe failed")
            return nil
        }
    }
    
    func getRecipeByID(id: Int64) -> RecipeItem? {
        var item = RecipeItem(id: id)
        
        do {
            let selectQuery = recipeTable.filter(
                recipeID == id)
        
            for rItem in try db!.prepare(selectQuery) {
                item = RecipeItem(
                    id:             id,
                    title:          rItem[recipeTitle],
                    calories:       rItem[recipeCalories],
                    servings:       rItem[recipeServings],
                    readyTime:      rItem[recipeReadyTime],
                    prepTime:       rItem[recipePrepTime],
                    cookTime:       rItem[recipeCookTime],
                    instructions:   rItem[recipeInstructions],
                    primary:        rItem[recipePrimary],
                    secondary:      rItem[recipeSecondary],
                    tertiary:       rItem[recipeTertiary],
                    imagePath:      rItem[recipeImagePath])
            }
            
            return item
        } catch {
            print("Get recipe failed")
            return nil
        }
    }
    
    func getAllRecipes() -> [Int64] {
        var recipeIDs = Set<Int64>()
        
        do {
            let selectQuery = recipeTable.filter(
                recipeID != -1)
            
            for item in try db!.prepare(selectQuery) {
                recipeIDs.insert(item[recipeID])
            }
            
            return Array(recipeIDs)
        } catch {
            print("Get recipeIDs failed")
            return Array(recipeIDs)
        }
    }
    
    func getRecipeIDsByCategory(category: String) -> [Int64] {
        var recipeIDs = Set<Int64>()
        
        do {
            let selectQuery = recipeTable.filter(
                recipePrimary == category ||
                recipeSecondary == category ||
                recipeTertiary  == category)
            
            for item in try db!.prepare(selectQuery) {
                recipeIDs.insert(item[recipeID])
            }
            
            return Array(recipeIDs)
        } catch {
            print("Get recipeIDs failed")
            return Array(recipeIDs)
        }
    }
    
    func deleteRecipe(id: Int64) -> Int64 {
        do {
            let deleteQuery = recipeTable.filter(
                recipeID == id)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete recipe failed")
            return 0
        }
    }
    
    // INGREDIENT TABLE DIVIDER
    
    func createIngredientTable() {
        do {
            
            if (deleteIngredientTable) {
                try db?.run(ingredientTable.drop(ifExists: true))
            }
            
            try db!.run(ingredientTable.create(ifNotExists: true) { table in
                table.column(ingredientID, primaryKey: true)
                table.column(ingredientRecipeID)
                table.column(ingredientName)
                table.column(ingredientUnit)
                table.column(ingredientQuantity)
            })
        } catch {
            print("Unable to create recipe table")
        }
    }
    
    func insertIngredient(recipeID: Int64, name: String, unit: String, quantity: Double) -> Int64? {
        do {
            let insert = ingredientTable.insert(
                ingredientRecipeID      <- recipeID,
                ingredientName          <- name,
                ingredientUnit          <- unit,
                ingredientQuantity      <- quantity)
            
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Error info: \(error)")
            print("Insert ingredient failed")
            return nil
        }
    }
    
    func updateIngredient(ingredientID: Int64, recipeID: Int64, name: String, unit: String, quantity: Double) -> Int64? {
        do {
            let updateQuery = ingredientTable.filter(
                self.ingredientID == ingredientID)
            
            let id = try db!.run(updateQuery.update(
                ingredientName          <- name,
                ingredientUnit          <- unit,
                ingredientQuantity      <- quantity))
            
            return Int64(id)
        } catch {
            print("Update ingredient failed")
            return nil
        }
    }
    
    func getIngredientsByRecipeID(recipeID: Int64) -> [RecipeIngredient] {
        var ingredients = [RecipeIngredient]()
        
        do {
            let selectQuery = ingredientTable.filter(
                ingredientRecipeID == recipeID)
            
            for iItem in try db!.prepare(selectQuery) {
                let ingredient = RecipeIngredient(
                    id:           iItem[ingredientID],
                    recipeID:     recipeID,
                    name:         iItem[ingredientName],
                    unit:         iItem[ingredientUnit],
                    quantity:     iItem[ingredientQuantity])
                
                ingredients.append(ingredient)
            }
            
            return ingredients
            
        } catch {
            print("Get ingredients failed")
            return ingredients
        }
    }
    
    func getRecipeIDByIngredient(ingredient: String) -> [Int64] {
        var recipeIDs = Set<Int64>()
        
        do {
            let selectQuery = ingredientTable.filter(
                ingredientName == ingredient)
            
            for iItem in try db!.prepare(selectQuery) {
                recipeIDs.insert(iItem[ingredientRecipeID])
            }
            
            return Array(recipeIDs)
        } catch {
            print("Get recipeIDs failed")
            return Array(recipeIDs)
        }
        
    }
    
    func deleteIngredient(ingredientID: Int64) -> Int64 {
        do {
            let deleteQuery = ingredientTable.filter(
                self.ingredientID == ingredientID)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete ingredient failed")
            return 0
        }
    }
    
    // PANTRY TABLE DIVIDER
    
    func createPantryTable() {
        do {
            if (deletePantryTable) {
                try db?.run(pantryTable.drop(ifExists: true))
            }
            
            try db!.run(pantryTable.create(ifNotExists: true) { table in
                table.column(pantryItemId, primaryKey: true)
                table.column(pantryItemName)
                table.column(pantryItemGroup)
                table.column(pantryItemQuantity)
                table.column(pantryItemUnit)
                table.column(pantryItemCalories)
                table.column(pantryItemExpiration)
                table.column(pantryItemPurchase)
                table.column(pantryItemArchived)
                table.column(pantryItemArchive)
                table.column(pantryItemToggle)
                table.column(pantryItemSearch)
            })
        } catch {
            print("Unable to create Pantry table")
        }
    }
    
    // insert a new pantry item
    func storePantryItem(name: String, group: String, quantity: Double, unit: String, calories: Int, expiration: Date, purchase: Date, archive: Date) -> Int64? {
        do {
            let insert = pantryTable.insert(
                pantryItemName          <- name,
                pantryItemGroup         <- group,
                pantryItemQuantity      <- quantity,
                pantryItemUnit          <- unit,
                pantryItemCalories      <- calories,
                pantryItemArchived      <- 0,
                pantryItemExpiration    <- expiration,
                pantryItemPurchase      <- purchase,
                pantryItemArchive       <- archive,
                pantryItemToggle        <- 0,
                pantryItemSearch        <- 0)
            
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert pantry item failed")
            print("Error info: \(error)")
            return nil
        }
    }
    
    // return pantry item as an object
    func getPantryItem(pantryId: Int64) -> PantryItem {
        var item = PantryItem(id: pantryId)
        
        do {
            let selectQuery = pantryTable.filter(pantryItemId == pantryId)
            
            for pItem in try db!.prepare(selectQuery) {
                item = PantryItem(
                    id:          pantryId,
                    name:        pItem[pantryItemName],
                    group:       pItem[pantryItemGroup],
                    quantity:    pItem[pantryItemQuantity],
                    unit:        pItem[pantryItemUnit],
                    calories:    pItem[pantryItemCalories]!,
                    isArchive:   pItem[pantryItemArchived],
                    expiration:  pItem[pantryItemExpiration]!,
                    purchase:    pItem[pantryItemPurchase],
                    archive:     Date(),
                    toggle:      pItem[pantryItemToggle],
                    search:      pItem[pantryItemSearch])
            }
            
            return item
        } catch {
            print("Get pantry item failed")
            return item
        }
    }
    
    // return a group of pantry items as list of objects
    func getGroupPantryItem(pantryGroup: String) -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            var selectQuery = pantryTable.filter(
                pantryItemGroup == pantryGroup &&
                pantryItemArchived == 0)
            
            if (pantryGroup == Constants.PantryAll) {
                selectQuery = pantryTable.filter(
                    pantryItemArchived == 0)
            }
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:         pItem[pantryItemId],
                    name:       pItem[pantryItemName],
                    group:      pItem[pantryItemGroup],
                    quantity:   pItem[pantryItemQuantity],
                    unit:       pItem[pantryItemUnit],
                    calories:   pItem[pantryItemCalories]!,
                    isArchive:  pItem[pantryItemArchived],
                    expiration: pItem[pantryItemExpiration]!,
                    purchase:   pItem[pantryItemPurchase],
                    archive:    Date(),
                    toggle:     pItem[pantryItemToggle],
                    search:     pItem[pantryItemSearch])
                
                items.append(item)
            }
            
            return items
        } catch {
            print("Get group of pantry item failed")
            return items
        }
    }
    
    // Get pantry items in a depending on group and whether it is stale
    func getPantryItems(pantryGroup: String, isFresh: Bool) -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            
            var staleDate: Date {
                return NSCalendar.current.date(
                    byAdding: .day,
                    value: getExpiration(expirationGroup: pantryGroup).expirationDays,
                    to: Date())!
            }
            
            let selectQuery = pantryTable.filter(
                pantryItemGroup == pantryGroup  &&
                pantryItemArchived == 0         &&
                ((pantryItemExpiration == nil || pantryItemExpiration > staleDate) == isFresh))
            
            for pItem in try db!.prepare(selectQuery) {
                
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        Date(),
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
            }
        } catch {
            print("Get group of fresh pantry item failed")
            return items
        }
    
        return items
    }
    
    // return archived pantry items as list of objects
    func getGroupPantryItemArchived() -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(
                pantryItemArchived == 1).order(pantryItemArchived)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        pItem[pantryItemArchive]!,
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
                
            }
            
            return items
        } catch {
            print("Get archived of pantry item failed")
            return items
        }
    }
    
    // update an existing pantry item
    func updatePantryItem(pantryId: Int64, name: String, group: String, quantity: Double, unit: String, calories: Int, expiration: Date, purchase: Date, archive: Date) -> Int64 {
        do {
            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemName          <- name,
                    pantryItemGroup         <- group,
                    pantryItemQuantity      <- quantity,
                    pantryItemUnit          <- unit,
                    pantryItemCalories      <- calories,
                    pantryItemArchived      <- 0,
                    pantryItemExpiration    <- expiration,
                    pantryItemPurchase      <- purchase,
                    pantryItemArchive       <- archive))
            
            return Int64(id)
        } catch {
            print("Update pantry item failed")
            return -1
        }
    }
    
    // delete pantry item entry
    func deletePantryItem(pantryId: Int64) -> Int64 {
        do {
            let deleteQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete pantry item failed")
            return -1
        }
    }
    
    // archive a pantry item and mark as archived & update archive date
    func archivePantryItem(pantryId: Int64) -> Int64 {
        do {
            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemArchived  <- 1,
                    pantryItemArchive   <- Date()))
            
            return Int64(id)
        } catch {
            print("Archive pantry item failed")
            return -1
        }
    }
    
    // toggle a pantry item and mark as toggle
    func togglePantryItem(pantryId: Int64, current: Int) -> Int64 {
        do {
            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemToggle <- 1-current))
            
            return Int64(id)
        } catch {
            print("Toggle pantry item failed")
            return -1
        }
    }
    
    // mark a pantry item for search
    func setSearchPantryItem(pantryId: Int64, current: Int) -> Int64 {
        do {
            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemSearch <- 1-current))
            
            return Int64(id)
        } catch {
            print("Mark pantry item as search failed")
            return -1
        }
    }
    
    // get all toggled Pantry Items
    func getToggledPantryItems() -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(pantryItemToggle == 1)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        Date(),
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
            }
            
            return items
        } catch {
            print("Get toggled pantry item ailed")
            return items
        }
    }
    
    // get all search Pantry Items
    func getSearchPantryItems() -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(pantryItemSearch == 1)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        Date(),
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
            }
            
            return items
        } catch {
            print("Get search pantry item ailed")
            return items
        }
    }
    
    // delete all toggled Pantry Items
    func deleteToggledPantryItems() -> Int64 {
        do {
            let deleteQuery = pantryTable.filter(
                pantryItemToggle == 1)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)

        } catch {
            print("Delete toggled pantry item ailed")
            return 0
        }
    }
    
    // revert all Pantry Items marked as search
    func revertSearchPantryItems() -> Int64 {
        do {
            let revertQuery = pantryTable.filter(
                pantryItemSearch == 1)
            
            let id = try db!.run(
                revertQuery.update(
                    pantryItemSearch <- 0))
            
            return Int64(id)
            
        } catch {
            print("Revert search pantry item ailed")
            return 0
        }
    }
    
    // get all Pantry Items with given name, ordered by expiration date
    func getPantryItemsByName(itemName: String) -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(
                pantryItemName.lowercaseString == itemName.lowercased() &&
                pantryItemArchived == 0).order(
                    pantryItemExpiration)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        Date(),
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
            }
            
            return items
        } catch {
            print("Get pantry item by name failed")
            return items
        }
    }
    
    // get all active Pantry Items, ordered by expiration date
    func getAllPantryItems() -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(
                pantryItemArchived == 0).order(
                    pantryItemExpiration)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id:             pItem[pantryItemId],
                    name:           pItem[pantryItemName],
                    group:          pItem[pantryItemGroup],
                    quantity:       pItem[pantryItemQuantity],
                    unit:           pItem[pantryItemUnit],
                    calories:       pItem[pantryItemCalories]!,
                    isArchive:      pItem[pantryItemArchived],
                    expiration:     pItem[pantryItemExpiration]!,
                    purchase:       pItem[pantryItemPurchase],
                    archive:        Date(),
                    toggle:         pItem[pantryItemToggle],
                    search:         pItem[pantryItemSearch])
                
                items.append(item)
            }
            
            return items
        } catch {
            print("Get all pantry items failed")
            return items
        }
    }
    
    // PANTRY EXPIRATION TABLE DIVIDER
    
    func createPantryExpirationTable() {
        do {
            try db!.run(pantryExpirationTable.create(ifNotExists: true) { table in
                table.column(pantryExpirationID, primaryKey: true)
                table.column(pantryExpirationGroup)
                table.column(pantryExpirationDays)
            })
        } catch {
            print("Unable to create Recipe table")
        }
    }
    
    func expirationDaysCount() -> Int {
        var count = -1
        do {
            count = try db!.scalar(pantryExpirationTable.count)
        } catch {
            print("Unable to select pantry expiration data")
        }
        
        return count
    }
    
    func initializeExpiration() {
        for groupName in Constants.pantryGroups {
            _ = SQLiteDB.instance.insertNewName(expirationGroup: groupName, expirationDays: getExpiration(expirationGroup: groupName).expirationDays)
        }
    }
    
    // Insert new list into the historic list
    func insertNewName(expirationGroup: String, expirationDays: Int) -> Int64? {
        do {
            let insert = pantryExpirationTable.insert(
                pantryExpirationGroup   <- expirationGroup,
                pantryExpirationDays    <- expirationDays)
            
            let id = try db!.run(insert)
            
            print("insert new expiration name successful")
            return id
        } catch {
            print("Insert expiration name failed")
            return nil
        }
    }
    
    // Update an existing historic list
    func updateBasedOnGroup(expirationGroup: String, expirationDays: Int) -> Int64? {
        do {
            let updateQuery = pantryExpirationTable.filter(
                pantryExpirationGroup == expirationGroup)
            let id = try db!.run(
                updateQuery.update(
                    pantryExpirationDays <- expirationDays))
            return Int64(id)
        } catch {
            print("Update expiration days failed")
            return nil
        }
    }
    
    // Delete an existing historic list
    func deleteGroup(expirationGroup: String) -> Int64? {
        do {
            let deleteQuery = pantryExpirationTable.filter(
                pantryExpirationGroup == expirationGroup)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete expiration name failed")
            return nil
        }
    }
    
    // Get the detailed information for a particular shopping item
    func getExpiration(expirationGroup: String) -> PantryExpiration {
        var item = PantryExpiration(id: 0)
        do {
            let selectQuery = pantryExpirationTable.filter(
                pantryExpirationGroup == expirationGroup)
            
            for res in try db!.prepare(selectQuery) {
                item = PantryExpiration(
                    id:                 res[pantryExpirationID],
                    expirationGroup:    res[pantryExpirationGroup],
                    expirationDays:     res[pantryExpirationDays])
            }
            
            return item
        } catch {
            print("Get shopping item information")
            return item
        }
    }
    
    // SHOPPING LISTS TABLE DIVIDER

    // Create shopping lists table
    func createShoppingListsTable() {
        do {
            if(deleteShoppingLists) {
                try db!.run(shoppingListsTable.drop())
            }
            try db!.run(shoppingListsTable.create(ifNotExists: true) { table in
                table.column(shoppingListsID, primaryKey: .autoincrement)
                table.column(shoppingListsCost)
                table.column(shoppingListsDate)
                table.column(shoppingListsIsActive)
            })
        } catch {
            print("Unable to create Shopping Lists table")
        }
    }
    
    // Insert new list into the historic list
    func insertNewList(listCost: Double, listDate: Date, isActive: Bool) -> Int64? {
        do {
            let insert = shoppingListsTable.insert(
                shoppingListsCost       <- listCost,
                shoppingListsDate       <- listDate,
                shoppingListsIsActive   <- isActive)
            
            let id = try db!.run(insert)
            
            print("insert new list successful")
            return id
        } catch {
            print("Insert shopping list failed")
            return nil
        }
    }
    
    // Update an existing historic list
    func updateList(listID: Int64, listCost: Double, listDate: Date, isActive: Bool) -> Int64? {
        do {
            let updateQuery = shoppingListsTable.filter(
                shoppingListsID == listID)
            let id = try db!.run(
                updateQuery.update(
                    shoppingListsCost       <- listCost,
                    shoppingListsDate       <- listDate,
                    shoppingListsIsActive   <- isActive))
            return Int64(id)
        } catch {
            print("Update shopping list failed")
            return nil
        }
    }
    
    // Delete an existing historic list
    func deleteList(listID: Int64) -> Int64? {
        do {
            let deleteQuery = shoppingListsTable.filter(
                shoppingListsID == listID)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete shopping list failed")
            return nil
        }
    }
    
    // Get the listID of the currently active shopping list
    func getActiveListID() -> Int64? {
        do {
            var id = Int64(0)
            
            let selectQuery = shoppingListsTable.filter(
                shoppingListsIsActive == true)
            
            for returnRow in try db!.prepare(selectQuery) {
                id = returnRow[shoppingListsID]
            }
            
            return id
        } catch {
            print("Fetching active list id failed")
            return nil
        }
    }
    
    // Get the detailed information for a particular shopping list
    func getListInformation(listID: Int64) -> ShoppingLists {
        var list = ShoppingLists(listID: listID)
        
        do {
            let selectQuery = shoppingListsTable.filter(shoppingListsID == listID)
            
            for sList in try db!.prepare(selectQuery) {
                list = ShoppingLists(
                    listID:     listID,
                    listCost:   sList[shoppingListsCost],
                    listDate:   sList[shoppingListsDate],
                    isActive:   sList[shoppingListsIsActive])
            }
            return list
        } catch {
            print("Get shopping list failed")
            return list
        }
    }
    
    // Check if a list is active
    func isActive(listID: Int64) -> Bool {
        do {
            let selectQuery = shoppingListsTable.filter(
                shoppingListsID == listID &&
                shoppingListsIsActive == true)
            
            for _ in try db!.prepare(selectQuery) {
                return true
            }
            return false
        } catch {
            print("Verifying if a list is active failed")
            return false
        }
    }
    
    // Get all historic shopping lists (except the active one)
    func getInactiveList() -> [Int64] {
        var inactiveIDs = Set<Int64>()
        
        do {
            let selectQuery = shoppingListsTable.filter(
                shoppingListsIsActive == false)
            
            for list in try db!.prepare(selectQuery) {
                inactiveIDs.insert(list[shoppingListsID])
            }
            
            return Array(inactiveIDs)
        } catch {
            print("Cannot get inactive shopping lists")
            return Array(inactiveIDs)
        }
    }
    
    // SHOPPING ITEM TABLE DIVIDER
    
    // Create the shopping item table
    func createShoppingItemTable() {
        do {
            
            if(deleteShoppingItem) {
                try db!.run(shoppingItemTable.drop())
            }
            
            try db!.run(shoppingItemTable.create(ifNotExists: true) { table in
                table.column(shoppingItemListID)
                table.column(shoppingItemID, primaryKey: .autoincrement)
                table.column(shoppingItemName)
                table.column(shoppingItemCost)
                table.column(shoppingItemUnit)
                table.column(shoppingItemQuantity)
                table.column(shoppingItemCategory)
                table.column(shoppingItemPurchased)
                table.column(shoppingItemExpirationDate)
                table.column(shoppingItemRepurchase)
            })
        } catch {
            print("Unable to create Shopping Item table")
        }
    }
    
    // Insert a new shopping item into the active list
    func insertNewItem(listID: Int64, itemName: String, itemCost: Double, unit: String, quantity: Double, group: String, purchased: Bool, expirationDate: Date, repurchase: Bool) -> Int64? {
        do {
            let insert = shoppingItemTable.insert(
                shoppingItemListID          <- listID,
                shoppingItemName            <- itemName,
                shoppingItemCost            <- itemCost,
                shoppingItemUnit            <- unit,
                shoppingItemQuantity        <- quantity,
                shoppingItemCategory        <- group,
                shoppingItemPurchased       <- purchased,
                shoppingItemExpirationDate  <- expirationDate,
                shoppingItemRepurchase      <- repurchase)
            
            let id = try db!.run(insert)
            
            print("insert sucessful")
            return id
        } catch {
            print("Insert shopping item failed")
            return nil
        }
    }
    
    // Update an existing item
    func updateItem(listID: Int64, itemID: Int64, itemName: String, itemCost: Double, unit: String, quantity: Double, group: String, purchased: Bool, expirationDate: Date, repurchase: Bool) -> Int64? {
        do {
            let updateQuery = shoppingItemTable.filter(shoppingItemListID == listID && shoppingItemID == itemID)
    
            let id = try db!.run(
                updateQuery.update(
                    shoppingItemListID              <- listID,
                    shoppingItemName                <- itemName,
                    shoppingItemCost                <- itemCost,
                    shoppingItemUnit                <- unit,
                    shoppingItemQuantity            <- quantity,
                    shoppingItemCategory            <- group,
                    shoppingItemPurchased           <- purchased,
                    shoppingItemExpirationDate      <- expirationDate,
                    shoppingItemRepurchase          <- repurchase))
            
            print("update item succesful")
            return Int64(id)
        } catch {
            print("Update shopping item failed")
            return nil
        }
    }
    
    // Delete an existing item
    func deleteItem(listID: Int64, itemID: Int64) -> Int64? {
        do {
            let deleteQuery = shoppingItemTable.filter(
                shoppingItemListID == listID &&
                    shoppingItemID == itemID)
            
            let id = try db!.run(deleteQuery.delete())
            
            print("item successfully deleted")
            return Int64(id)
        } catch {
            print("Deleting existing shopping list item failed")
            return nil
        }
    }
    
    // Verify if an item has been purchased
    func isPurchased(listID: Int64, itemID: Int64) -> Bool {
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemListID == listID &&
                    shoppingItemID == itemID &&
                    shoppingItemPurchased == true)
            
            for _ in try db!.prepare(selectQuery) {
                return true
            }
            return false
        } catch {
            print("Verifying if an item is purchased failed")
            return false
        }
    }
    
    // Get the detailed information for a particular shopping item
    func getItemInformation(listID: Int64, itemID: Int64) -> ShoppingItem {
        var item = ShoppingItem(id: itemID)
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemListID == listID &&
                    shoppingItemID == itemID)
            
            for sItem in try db!.prepare(selectQuery) {
                item = ShoppingItem(
                    listID:             listID,
                    itemID:             itemID,
                    itemName:           sItem[shoppingItemName],
                    itemCost:           sItem[shoppingItemCost],
                    unit:               sItem[shoppingItemUnit],
                    quantity:           sItem[shoppingItemQuantity],
                    group:              sItem[shoppingItemCategory],
                    purchased:          sItem[shoppingItemPurchased],
                    expirationDate:     sItem[shoppingItemExpirationDate]!,
                    repurchase:         sItem[shoppingItemRepurchase])
            }
            
            return item
        } catch {
            print("Get shopping item information")
            return item
        }
    }
    
    // Verify if an item has been marked for repurchase
    func isRepurchase(listID: Int64, itemID: Int64) -> Bool {
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemListID == listID &&
                    shoppingItemID == itemID &&
                    shoppingItemRepurchase == true)
            
            for _ in try db!.prepare(selectQuery) {
                return true
            }
            
            return false
        } catch {
            print("Verifying if an item is marked for repurchase failed")
            return false
        }
    }
    
    // Get the itemIDs marked for repurchase
    func getMarkedItemIDs(listID: Int64) -> [Int64] {
        var markedIDs = Set<Int64>()
        
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemRepurchase == true &&
                    shoppingListsID == listID)
            
            for item in try db!.prepare(selectQuery) {
                markedIDs.insert(item[shoppingItemID])
            }
            
            return Array(markedIDs)
        } catch {
            print("Cannot get items related to listID")
            return Array(markedIDs)
        }
    }
    
    // Get the itemIDs related to a shopping list
    func getItemIDs(listID: Int64) -> [Int64] {
        var itemIDs = Set<Int64>()
        
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemListID == listID)
            
            for item in try db!.prepare(selectQuery) {
                itemIDs.insert(item[shoppingItemID])
            }
            
            return Array(itemIDs)
        } catch {
            print("Cannot get items related to listID")
            return Array(itemIDs)
        }
    }
    
    // Get the itemIDs related to a shopping list with a particular name
    func getShoppingItemByName(listID: Int64, name: String) -> ShoppingItem {
        var shoppingItem = ShoppingItem(id: -1)
        
        do {
            let selectQuery = shoppingItemTable.filter(
                shoppingItemListID == listID &&
                shoppingItemName == name)
            
            for sItem in try db!.prepare(selectQuery) {
                shoppingItem = ShoppingItem(
                    listID:             listID,
                    itemID:             sItem[shoppingItemID],
                    itemName:           name,
                    itemCost:           sItem[shoppingItemCost],
                    unit:               sItem[shoppingItemUnit],
                    quantity:           sItem[shoppingItemQuantity],
                    group:              sItem[shoppingItemCategory],
                    purchased:          sItem[shoppingItemPurchased],
                    expirationDate:     sItem[shoppingItemExpirationDate]!,
                    repurchase:         sItem[shoppingItemRepurchase])
            }
            
            return shoppingItem
        } catch {
            print("Cannot get items related to listID & name")
            return shoppingItem
        }
    }
    
}
