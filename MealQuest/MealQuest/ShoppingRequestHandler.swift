//
//  ShoppingRequestHandler.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

func getActiveList() -> [ShoppingItem] {
    var activeList = [ShoppingItem]()
    let activeListID = SQLiteDB.instance.getActiveListID()
    if(activeListID == 0) {
        print("no current active list...")
        print("inserting new active list")
        let date = Date()
        _ = SQLiteDB.instance.insertNewList(listCost: 0, listDate: date, isActive: true)
    } else {
        let itemIDs = SQLiteDB.instance.getItemIDs(listID: activeListID!)
        for itemID in itemIDs {
            let itemInfo = SQLiteDB.instance.getItemInformation(listID: activeListID!, itemID: itemID)
            activeList.append(itemInfo)
        }
    }
    return activeList.sorted(by: <)
}

func getShoppingItemDetail(ItemID: Int64) -> ShoppingItem {
    let activeListID = SQLiteDB.instance.getActiveListID()
    
    return SQLiteDB.instance.getItemInformation(listID: activeListID!, itemID: ItemID)
}

func changePurchasedState(ItemID: Int64, purchasedState: Bool) {
    let activeListID = SQLiteDB.instance.getActiveListID()
    let itemInfo = SQLiteDB.instance.getItemInformation(listID: activeListID!, itemID: ItemID)
    _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: ItemID, itemName: itemInfo.name, itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: purchasedState, expirationDate: itemInfo.expirationDate, repurchase: itemInfo.repurchase)
}

func changeRepurchaseState(ListID: Int64, ItemID: Int64, repurchaseState: Bool) {
    let itemInfo = SQLiteDB.instance.getItemInformation(listID: ListID, itemID: ItemID)
    _ = SQLiteDB.instance.updateItem(listID: ListID, itemID: ItemID, itemName: itemInfo.name, itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: itemInfo.purchased, expirationDate: itemInfo.expirationDate, repurchase: repurchaseState)
}

func shoppingCheckout(_ listCost: Double) {
    var activeList = [ShoppingItem]()
    var boughtItems = [ShoppingItem]()
    let activeListID = SQLiteDB.instance.getActiveListID()
    
    if(activeListID == 0) {
        let date = Date()
        _ = SQLiteDB.instance.insertNewList(listCost: 0, listDate: date, isActive: true)
    } else {
        let itemIDs = SQLiteDB.instance.getItemIDs(listID: activeListID!)
        for itemID in itemIDs {
            let itemInfo = SQLiteDB.instance.getItemInformation(listID: activeListID!, itemID: itemID)
            if(itemInfo.purchased) {
                boughtItems.append(itemInfo)
            } else {
                activeList.append(itemInfo)
                _ = SQLiteDB.instance.deleteItem(listID: activeListID!, itemID: itemID)
            }
        }
        
        // call to Mary's function with boughtItems as the parameter
        addCheckedOutItemsToPantry(items: boughtItems)
        
        // Update current list to become historical
        let date = Date()
        _ = SQLiteDB.instance.updateList(listID: activeListID!, listCost: listCost, listDate: date, isActive: false)
        
        // Create new list
        _ = SQLiteDB.instance.insertNewList(listCost: 0, listDate: date, isActive: true)
        let activeListID = SQLiteDB.instance.getActiveListID()
        for itemInfo in activeList {
            _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: itemInfo.name, itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: itemInfo.purchased, expirationDate: itemInfo.expirationDate, repurchase: itemInfo.repurchase)
        }
    }
}

func deleteShoppingItem(_ itemID: Int64) {
    let activeListID = SQLiteDB.instance.getActiveListID()
    _ = SQLiteDB.instance.deleteItem(listID: activeListID!, itemID: itemID)
}

func updateShoppingItem(_ itemInfo: ShoppingItem) {
     let activeListID = SQLiteDB.instance.getActiveListID()
    _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: itemInfo.id, itemName: itemInfo.name, itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: itemInfo.purchased, expirationDate: itemInfo.expirationDate, repurchase: itemInfo.repurchase)
}

func saveNewShoppingItem(_ itemInfo: ShoppingItem) {
    let activeListID = SQLiteDB.instance.getActiveListID()
    let activeItem = SQLiteDB.instance.getShoppingItemByName(listID: activeListID!, name: itemInfo.name)
    if (activeItem.listID == -1 || activeItem.group != itemInfo.group) {
        _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: itemInfo.name, itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: itemInfo.purchased, expirationDate: itemInfo.expirationDate, repurchase: itemInfo.repurchase)
    } else {
        let aggregateQuantity = activeItem.quantity + convert(itemInfo.quantity, itemInfo.unit, activeItem.unit)
        
        _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: activeItem.id, itemName: activeItem.name, itemCost: activeItem.itemCost + itemInfo.itemCost, unit: activeItem.unit, quantity: aggregateQuantity, group: activeItem.group, purchased: false, expirationDate: activeItem.expirationDate, repurchase: false)
    }
}

func getHistoricLists() -> [ShoppingLists] {
    var historicLists = [ShoppingLists]()
    let inactiveListIDs = SQLiteDB.instance.getInactiveList()
    for id in inactiveListIDs {
        let listInfo = SQLiteDB.instance.getListInformation(listID: id)
        historicLists.append(listInfo)
    }
    return historicLists.sorted(by: >)
}

func deleteHistoricList(_ listID: Int64) {
    let itemIDs = SQLiteDB.instance.getItemIDs(listID: listID)
    for itemID in itemIDs {
        _ = SQLiteDB.instance.deleteItem(listID: listID, itemID: itemID)
    }
    _ = SQLiteDB.instance.deleteList(listID: listID)
}

func getSelectedShoppingList(_ listID: Int64) -> [ShoppingItem] {
    var shoppingList = [ShoppingItem]()
    let itemIDs = SQLiteDB.instance.getItemIDs(listID: listID)
    for itemID in itemIDs {
        let itemInfo = SQLiteDB.instance.getItemInformation(listID: listID, itemID: itemID)
        shoppingList.append(itemInfo)
    }
    return shoppingList.sorted(by: <)
}

func getAllShoppingItems() -> [ShoppingItem] {
    var allShoppingItems = Set<ShoppingItem>()
    let inactiveListIDs = SQLiteDB.instance.getInactiveList()
    for listID in inactiveListIDs {
        let itemIDs = SQLiteDB.instance.getItemIDs(listID: listID)
        for itemID in itemIDs {
            let itemInfo = SQLiteDB.instance.getItemInformation(listID: listID, itemID: itemID)
            if(allShoppingItems.contains(itemInfo)) {
                print("removing item")
                let existingItem = allShoppingItems.remove(itemInfo)!
                let oldUnit = existingItem.unit
                let oldQuantity = existingItem.quantity
                let oldItemCost = existingItem.itemCost
                let newUnit = itemInfo.unit
                let newQuantity = itemInfo.quantity
                let newItemCost = itemInfo.itemCost
                let oldQuantityToNew = convert(oldQuantity, oldUnit, newUnit)
                if(oldQuantityToNew == 0) {
                    allShoppingItems.insert(itemInfo)
                    allShoppingItems.insert(existingItem)
                } else {
                    if(oldItemCost/oldQuantityToNew > newItemCost/newQuantity) {
                        allShoppingItems.insert(itemInfo)
                    } else {
                        allShoppingItems.insert(existingItem)
                    }
                }
                
            } else {
                print("no previous item found")
                allShoppingItems.insert(itemInfo)
            }
        }
    }
    let pantryItems = SQLiteDB.instance.getAllPantryItems()
    for pItem in pantryItems {
        let itemInfo = ShoppingItem(listID: -1, itemID: -1, itemName: pItem.name, itemCost: 0, unit: pItem.unit, quantity: pItem.quantity, group: pItem.group, purchased: false, expirationDate: pItem.expiration, repurchase: false)
        if(!allShoppingItems.contains(itemInfo)) {
            print("no previous item found")
            allShoppingItems.insert(itemInfo)
        }
    }

    return allShoppingItems.sorted(by: <)
}

func addSelectedItemsToShoppingList(_ listID: Int64) {
    let markedItemIDs = SQLiteDB.instance.getMarkedItemIDs(listID: listID)
    let activeListID = SQLiteDB.instance.getActiveListID()
    for itemID in markedItemIDs {
        let itemInfo = SQLiteDB.instance.getItemInformation(listID: listID, itemID: itemID)
        _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: itemInfo.name , itemCost: itemInfo.itemCost, unit: itemInfo.unit, quantity: itemInfo.quantity, group: itemInfo.group, purchased: false, expirationDate: itemInfo.expirationDate, repurchase: false)
    }
}

// add array of ShoppingItems to pantry db
func addCheckedOutItemsToPantry(items: [ShoppingItem]) {
    for item in items {
        let expireDate = SQLDateFormatter.string(from: item.expirationDate)
        _ = SQLiteDB.instance.storePantryItem(name: item.name, group: item.group, quantity: item.quantity, unit: item.unit, calories: 0, expiration: expireDate, purchase: Date().datatypeValue, archive: "")
    }
}

func addPantryItemsToShoppingList(_ pantryItems: [PantryItem]) {
    let activeListID = SQLiteDB.instance.getActiveListID()
    let date = Date()
    for item in pantryItems {
        _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: item.name, itemCost: 0, unit: item.unit, quantity: Double(item.quantity), group: item.group, purchased: false, expirationDate: date, repurchase: false)
    }
}



