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
    
    // Testing constant to reset database (pantry, shopping list and shopping item)
    private let testingConstant = false
    private let deleteFoodTable = false
    private let deletePantryTable = false
    private let deleteShoppingLists = false
    private let deleteShoppingItem = false
    
    // Recipe table
    private let recipeTable = Table("recipes")
    private let recipeId = Expression<Int64>("id")
    private let recipeAPIId = Expression<Int64>("APIid")
    private let recipeField = Expression<String?>("field")
    private let recipeFieldData = Expression<String?>("fieldData")
    private let isFavourite = Expression<Int64>("isFavourite")
    
    // Pantry items table
    private let pantryTable = Table("pantry")
    private let pantryItemId = Expression<Int64>("id")
    private let pantryItemName = Expression<String>("name")
    private let pantryItemGroup = Expression<String>("group")
    private let pantryItemQuantity = Expression<Double>("quantity")
    private let pantryItemUnit = Expression<String>("unit")
    private let pantryItemCalories = Expression<Int?>("calories")
    private let pantryItemArchived = Expression<Int>("isArchived")
    private let pantryItemToggle = Expression<Int>("toggle")
    private let pantryItemSearch = Expression<Int>("search")
    // dates
    private let pantryItemExpiration = Expression<Date?>("expiration")
    private let pantryItemPurchase = Expression<Date>("purchase")
    private let pantryItemArchive = Expression<Date?>("archive")
    
    // expiration factors - expiring within factor => stale
    private let dairyStaleFactor = 5
    private let proteinStaleFactor = 2
    private let veggieStaleFactor = 2
    private let bakeryStaleFactor = 5
    
    // Shopping Lists Table
    private let shoppingListsTable = Table("shoppingLists")
    private let shoppingListsID = Expression<Int64>("listID")
    private let shoppingListsCost = Expression<Double>("listCost")
    private let shoppingListsDate = Expression<Date>("listDate")
    private let shoppingListsIsActive = Expression<Bool>("isActive")
    
    // Shopping Item Table
    private let shoppingItemTable = Table("shoppingItem")
    private let shoppingItemListID = Expression<Int64>("listID")
    private let shoppingItemID = Expression<Int64>("itemID")
    private let shoppingItemName = Expression<String>("itemName")
    private let shoppingItemCost = Expression<Double>("itemCost")
    private let shoppingItemUnit = Expression<String>("unit")
    private let shoppingItemQuantity = Expression<Double>("quantity")
    private let shoppingItemCategory = Expression<String>("group") // category
    private let shoppingItemPurchased = Expression<Bool>("purchased")
    private let shoppingItemExpirationDate = Expression<Date?>("expirationDate")
    private let shoppingItemRepurchase = Expression<Bool>("repurchase")
    
    let dateFormatter = DateFormatter()
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            createRecipeTable()
            createPantryTable()
            createShoppingListsTable()
            createShoppingItemTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    // RECIPE TABLE DIVIDER
    
    func createRecipeTable() {
        do {
            try db!.run(recipeTable.create(ifNotExists: true) { table in
                table.column(recipeId, primaryKey: true)
                table.column(recipeAPIId)
                table.column(recipeField)
                table.column(recipeFieldData)
                table.column(isFavourite)
            })
        } catch {
            print("Unable to create Recipe table")
        }
    }
    
    func storeRecipeToDB(recipeID: Int64, field: String, data: String) -> Int64? {
        do {
            let insert = recipeTable.insert(
                recipeAPIId <- recipeID,
                recipeField <- field,
                recipeFieldData <- data,
                isFavourite <- 0)
            
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert recipe field failed")
            return nil
        }
    }
    
    func updateRecipeInDB(recipeID: Int64, field: String, data: String) -> Int64? {
        do {
            let updateQuery = recipeTable.filter(
                recipeAPIId == recipeID &&
                recipeField == field)
            
            let id = try db!.run(updateQuery.update(recipeFieldData <- data))
            
            return Int64(id)
        } catch {
            print("Update recipe field failed")
            return nil
        }
    }
    
    func getRecipeFieldFromDB(recipeID: Int64) -> [String: String] {
        var recipeFields = [String: String]()
        
        do {
            let selectQuery = recipeTable.filter(
                recipeAPIId == recipeID)
        
            for recipe in try db!.prepare(selectQuery) {
                recipeFields[recipe[recipeField]!] = recipe[recipeFieldData]
            }
            
            return recipeFields
        } catch {
            print("Get recipe failed")
            return recipeFields
        }
    }
    
    func getFavouriteRecipeFieldFromDB() -> [Int64] {
        var favRecipeIds = Set<Int64>()
        
        do {
            
            let selectQuery = recipeTable.filter(
                isFavourite == 1)
            
            for recipe in try db!.prepare(selectQuery) {
                favRecipeIds.insert(
                    recipe[recipeAPIId])
            }
            
            return Array(favRecipeIds)
        } catch {
            print("Get favourite recipes failed")
            return Array(favRecipeIds)
        }
    }
    
    func deleteRecipeFromDB(recipeID: Int64) -> Int64 {
        do {
            let deleteQuery = recipeTable.filter(
                recipeAPIId == recipeID)
            
            let id = try db!.run(deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete recipe failed")
            return 0
        }
    }
    
    func addRecipeToFavouriteDB(recipeID: Int64) -> Int64 {
        do {
            let updateQuery = recipeTable.filter(
                recipeAPIId == recipeID)
            
            let id = try db!.run(
                updateQuery.update(
                    isFavourite <- 1))
            
            return Int64(id)
        } catch {
            print("Mark recipe as favourite failed")
            return 0
        }
    }
    
    func unmarkFavouriteRecipeDB(recipeID: Int64) -> Int64 {
        do {
            let updateQuery = recipeTable.filter(
                recipeAPIId == recipeID)
            
            let id = try db!.run(
                updateQuery.update(
                    isFavourite <- 0))
            
            return Int64(id)
        } catch {
            print("Unmark favourite recipe failed")
            return 0
        }
    }
    
    func deleteNonFavouriteRecipeDB() -> Int64 {
        do {
            let deleteQuery = recipeTable.filter(
                isFavourite == 0)
            
            let id = try db!.run(
                deleteQuery.delete())
            
            return Int64(id)
        } catch {
            print("Delete all non-favourite recipe failed")
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
    func storePantryItem(name: String, group: String, quantity: Double, unit: String, calories: Int, expiration: String, purchase: String, archive: String) -> Int64? {
        do {
            let archiveDate = convertDate(dateString: archive)
            let purchaseDate = convertDate(dateString: purchase)
            let expirationDate = convertDate(dateString: expiration)

            let insert = pantryTable.insert(
                pantryItemName          <- name,
                pantryItemGroup         <- group,
                pantryItemQuantity      <- quantity,
                pantryItemUnit          <- unit,
                pantryItemCalories      <- calories,
                pantryItemArchived      <- 0,
                pantryItemExpiration    <- expirationDate,
                pantryItemPurchase      <- purchaseDate!,
                pantryItemArchive       <- archiveDate,
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
    
    func sortByName(this: PantryItem, that: PantryItem) -> Bool {
        return this.name.lowercased() < that.name.lowercased()
    }
    
    /* TODO:
        Obs: this would get insanely long and complex with the pantry group enhancements
        1) refactor to iterate through each group in a for loop
            a) to do this: the stale dates need to be either included in a class with the pantryGroup or have a way to match them
     */
    // return a group of fresh pantry items as list of objects
    func getGroupPantryItemFresh(pantryGroup: String) -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            if (pantryGroup == Constants.PantryAll) {
                var dairyStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: dairyStaleFactor, to: Date())!
                }
                var selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryDairy && pantryItemArchived == 0 && pantryItemArchived == 0 && (pantryItemExpiration == nil || pantryItemExpiration > dairyStaleDate))
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var proteinStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: proteinStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryProteins && pantryItemArchived == 0 && pantryItemArchived == 0 && (pantryItemExpiration == nil || pantryItemExpiration > proteinStaleDate))
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var veggieStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: veggieStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryVeggies && pantryItemArchived == 0 && pantryItemArchived == 0 && (pantryItemExpiration == nil || pantryItemExpiration > veggieStaleDate))
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var bakeryStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: bakeryStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryBakery && pantryItemArchived == 0 && pantryItemArchived == 0 && (pantryItemExpiration == nil || pantryItemExpiration > bakeryStaleDate))
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                items.sort(by: sortByName)
                
                return items
                
            } else {
                var staleFactor = 0
                if (pantryGroup == Constants.PantryDairy) {
                    staleFactor = dairyStaleFactor
                } else if (pantryGroup == Constants.PantryProteins) {
                    staleFactor = proteinStaleFactor
                } else if (pantryGroup == Constants.PantryVeggies) {
                    staleFactor = veggieStaleFactor
                } else if (pantryGroup == Constants.PantryBakery) {
                    staleFactor = bakeryStaleFactor
                }
            
                var staleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: staleFactor, to: Date())!
                }
            
                var selectQuery = pantryTable.filter(pantryItemGroup == pantryGroup && pantryItemArchived == 0 && pantryItemArchived == 0 && ( pantryItemExpiration == nil || pantryItemExpiration > staleDate)).order(pantryItemName.lowercaseString)
            
                if (pantryGroup == Constants.PantryAll) {
                    selectQuery = pantryTable.filter(pantryItemArchived == 0 && pantryItemArchived == 0 && (pantryItemExpiration == nil || pantryItemExpiration > staleDate)).order(pantryItemName.lowercaseString)
                }
            
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup], quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
            
                return items
            }
        } catch {
            print("Get group of fresh pantry item failed")
            return items
        }
    }
    
    // return archived pantry items as list of objects
    func getGroupPantryItemArchived() -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            let selectQuery = pantryTable.filter(
                pantryItemArchived == 1).order(pantryItemArchived)
            
            for pItem in try db!.prepare(selectQuery) {
                let item = PantryItem(
                    id: pItem[pantryItemId],
                    name: pItem[pantryItemName],
                    group: pItem[pantryItemGroup],
                    quantity: pItem[pantryItemQuantity],
                    unit: pItem[pantryItemUnit],
                    calories: pItem[pantryItemCalories]!,
                    isArchive: pItem[pantryItemArchived],
                    expiration: pItem[pantryItemExpiration]!,
                    purchase: pItem[pantryItemPurchase],
                    archive: pItem[pantryItemArchive]!,
                    toggle: pItem[pantryItemToggle],
                    search: pItem[pantryItemSearch])
                
                items.append(item)
                
            }
            
            return items
        } catch {
            print("Get archived of pantry item failed")
            return items
        }
    }
    
    func sortByExpiration(this: PantryItem, that: PantryItem) -> Bool {
        return this.expiration < that.expiration
    }
    
    /* TODO: this was skipped; this is probably the exact same function as getting the fresh pantry items with a small modification to the query
     *  1) Create a handler to get fresh and stale items
        2) Modify the function above to account for that logic
        3) Then remove this
     */
    
    // return a group of "stale" pantry items as list of objects
    func getGroupPantryItemStale(pantryGroup: String) -> [PantryItem] {
        var items = [PantryItem]()
        
        do {
            if (pantryGroup == Constants.PantryAll) {
                var dairyStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: dairyStaleFactor, to: Date())!
                }
                var selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryDairy && pantryItemArchived == 0 && pantryItemExpiration <= dairyStaleDate)
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var proteinStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: proteinStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryProteins && pantryItemArchived == 0 && pantryItemExpiration <= proteinStaleDate)
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var veggieStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: veggieStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryVeggies && pantryItemArchived == 0 && pantryItemExpiration <= veggieStaleDate)
                
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                var bakeryStaleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: bakeryStaleFactor, to: Date())!
                }
                selectQuery = pantryTable.filter(pantryItemGroup == Constants.PantryBakery && pantryItemArchived == 0 && pantryItemExpiration <= bakeryStaleDate)
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                items.sort(by: sortByExpiration)
                
                return items
                
            } else {
                var staleFactor = 0
                if (pantryGroup == Constants.PantryDairy) {
                    staleFactor = dairyStaleFactor
                } else if (pantryGroup == Constants.PantryProteins) {
                    staleFactor = proteinStaleFactor
                } else if (pantryGroup == Constants.PantryVeggies) {
                    staleFactor = veggieStaleFactor
                } else if (pantryGroup == Constants.PantryBakery) {
                    staleFactor = bakeryStaleFactor
                }
            
                var staleDate: Date {
                    return NSCalendar.current.date(byAdding: .day, value: staleFactor, to: Date())!
                }
            
                var selectQuery = pantryTable.filter(pantryItemGroup == pantryGroup && pantryItemArchived == 0 && (pantryItemExpiration <= staleDate || pantryItemExpiration == nil)).order(pantryItemExpiration)
            
                if (pantryGroup == Constants.PantryAll) {
                    selectQuery = pantryTable.filter(pantryItemArchived == 0 && pantryItemExpiration <= staleDate).order(pantryItemExpiration)
                }
            
                for pItem in try db!.prepare(selectQuery) {
                    let item = PantryItem(id: pItem[pantryItemId], name: pItem[pantryItemName], group: pItem[pantryItemGroup],  quantity: pItem[pantryItemQuantity], unit: pItem[pantryItemUnit], calories: pItem[pantryItemCalories]!, isArchive: pItem[pantryItemArchived], expiration: pItem[pantryItemExpiration]!, purchase: pItem[pantryItemPurchase], archive: Date(), toggle: pItem[pantryItemToggle], search: pItem[pantryItemSearch])
                    items.append(item)
                }
                
                return items
            }
        } catch {
            print("Get stale group of pantry item failed")
            return items
        }
    }
    
    // update an existing pantry item
    func updatePantryItem(pantryId: Int64, name: String, group: String, quantity: Double, unit: String, calories: Int, expiration: String, purchase: String, archive: String) -> Int64? {
        do {
            var archiveDate: Date?
            archiveDate = nil
            if (archive != "") {
                archiveDate = Date.fromDatatypeValue(archive)
            }

            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemName <- name,
                    pantryItemGroup <- group,
                    pantryItemQuantity <- quantity,
                    pantryItemUnit <- unit,
                    pantryItemCalories <- calories,
                    pantryItemArchived <- 0,
                    pantryItemExpiration <- Date.fromDatatypeValue(expiration),
                    pantryItemPurchase <- Date.fromDatatypeValue(purchase),
                    pantryItemArchive <- archiveDate))
            
            return Int64(id)
        } catch {
            print("Update pantry item failed")
            return nil
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
            return 0
        }
    }
    
    // archive a pantry item and mark as archived & update archive date
    func archivePantryItem(pantryId: Int64) -> Int64 {
        do {
            let updateQuery = pantryTable.filter(
                pantryItemId == pantryId)
            
            let id = try db!.run(
                updateQuery.update(
                    pantryItemArchived <- 1,
                    pantryItemArchive <- Date()))
            
            return Int64(id)
        } catch {
            print("Archive pantry item failed")
            return 0
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
            return 0
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
            return 0
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
            print("Get search   pantry item ailed")
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
                shoppingListsCost <- listCost,
                shoppingListsDate <- listDate,
                shoppingListsIsActive <- isActive)
            
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
                    shoppingListsCost <- listCost,
                    shoppingListsDate <- listDate,
                    shoppingListsIsActive <- isActive))
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
                    listID: listID,
                    listCost: sList[shoppingListsCost],
                    listDate: sList[shoppingListsDate],
                    isActive: sList[shoppingListsIsActive])
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
                shoppingItemListID <- listID,
                shoppingItemName <- itemName,
                shoppingItemCost <- itemCost,
                shoppingItemUnit <- unit,
                shoppingItemQuantity <- quantity,
                shoppingItemCategory <- group,
                shoppingItemPurchased <- purchased,
                shoppingItemExpirationDate <- expirationDate,
                shoppingItemRepurchase <- repurchase)
            
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
                    shoppingItemListID <- listID,
                    shoppingItemName <- itemName,
                    shoppingItemCost <- itemCost,
                    shoppingItemUnit <- unit,
                    shoppingItemQuantity <- quantity,
                    shoppingItemCategory <- group,
                    shoppingItemPurchased <- purchased,
                    shoppingItemExpirationDate <- expirationDate,
                    shoppingItemRepurchase <- repurchase))
            
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
                    listID: listID,
                    itemID: itemID,
                    itemName: sItem[shoppingItemName],
                    itemCost: sItem[shoppingItemCost],
                    unit: sItem[shoppingItemUnit],
                    quantity: sItem[shoppingItemQuantity],
                    group: sItem[shoppingItemCategory],
                    purchased: sItem[shoppingItemPurchased],
                    expirationDate: sItem[shoppingItemExpirationDate]!,
                    repurchase: sItem[shoppingItemRepurchase])
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
                    listID: listID,
                    itemID: sItem[shoppingItemID],
                    itemName: name,
                    itemCost: sItem[shoppingItemCost],
                    unit: sItem[shoppingItemUnit],
                    quantity: sItem[shoppingItemQuantity],
                    group: sItem[shoppingItemCategory],
                    purchased: sItem[shoppingItemPurchased],
                    expirationDate: sItem[shoppingItemExpirationDate]!,
                    repurchase: sItem[shoppingItemRepurchase])
            }
            
            return shoppingItem
        } catch {
            print("Cannot get items related to listID & name")
            return shoppingItem
        }
    }
    
}
