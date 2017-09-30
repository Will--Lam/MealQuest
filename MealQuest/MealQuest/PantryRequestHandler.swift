//
//  PantryRequestHandler.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

func createPantryItem(itemInfo: PantryItem) -> Int64? {
    return SQLiteDB.instance.storePantryItem(
        name:           itemInfo.name,
        group:          itemInfo.group,
        quantity:       itemInfo.quantity,
        unit:           itemInfo.unit,
        calories:       itemInfo.calories,
        expiration:     itemInfo.expiration,
        purchase:       itemInfo.purchase,
        archive:        itemInfo.archive)
}

func updatePantryItem(itemInfo: PantryItem) -> Int64? {
    return SQLiteDB.instance.updatePantryItem(
        pantryId:       itemInfo.id,
        name:           itemInfo.name,
        group:          itemInfo.group,
        quantity:       itemInfo.quantity,
        unit:           itemInfo.unit,
        calories:       itemInfo.calories,
        expiration:     itemInfo.expiration,
        purchase:       itemInfo.purchase,
        archive:        itemInfo.archive)
}

func deletePantryItem(pantryId: Int64) -> Int64 {
    return SQLiteDB.instance.deletePantryItem(pantryId: pantryId)
}

func setSearchPantryItem(pantryId: Int64, searchValue: Int) {
    _ = SQLiteDB.instance.setSearchPantryItem(pantryId: pantryId, current: searchValue)
}

func togglePantryItem(pantryId: Int64, toggleValue: Int) {
    _ = SQLiteDB.instance.togglePantryItem(pantryId: pantryId, current: toggleValue)

}

func getToggledPantryItems() -> [PantryItem] {
    return SQLiteDB.instance.getToggledPantryItems()
}

func archivePantryItem(pantryId: Int64) {
    _ = SQLiteDB.instance.archivePantryItem(pantryId: pantryId)
}

func getGroupPantryItemArchived() -> [PantryItem] {
    return SQLiteDB.instance.getGroupPantryItemArchived()
}


func getGroupPantryItem(pantryGroup: String) -> [PantryItem] {
    return SQLiteDB.instance.getGroupPantryItem(pantryGroup: pantryGroup)
}

func getGroupPantryItemFresh(pantryGroup: String) -> [PantryItem] {
    var items = [PantryItem]()
    if (pantryGroup == Constants.PantryAll) {
        for pItem in Constants.pantryGroups {
            let pantryGroupItems = SQLiteDB.instance.getPantryItems(pantryGroup: pItem, isFresh: true)
            for newItem in pantryGroupItems {
                items.append(newItem)
            }
        }
    } else {
        items = SQLiteDB.instance.getPantryItems(pantryGroup: pantryGroup, isFresh: true)
    }
    
    items.sort(by: sortByName)
    
    return items
}

func getGroupPantryItemStale(pantryGroup: String) -> [PantryItem] {
    var items = [PantryItem]()
    
    if (pantryGroup == Constants.PantryAll) {
        for pItem in Constants.pantryGroups {
            let pantryGroupItems = SQLiteDB.instance.getPantryItems(pantryGroup: pItem, isFresh: false)
            for newItem in pantryGroupItems {
                items.append(newItem)
            }
        }
    } else {
        items = SQLiteDB.instance.getPantryItems(pantryGroup: pantryGroup, isFresh: false)
    }
    
    items.sort(by: sortByExpiration(this:that:))
    
    return items
}

func updateGroupExpiration(updateGroups: [String: Int]) {
    for item in updateGroups {
        _ = SQLiteDB.instance.updateBasedOnGroup(expirationGroup: item.key, expirationDays: item.value)
    }
}

func getAllGroupExpiration() -> [PantryExpiration] {
    var items = [PantryExpiration]()
    for groupName in Constants.pantryGroups {
        items.append(SQLiteDB.instance.getExpiration(expirationGroup: groupName))
    }
    return items
}

func getGroupExpiration(groupName: String) -> Int {
    return SQLiteDB.instance.getExpiration(expirationGroup: groupName).expirationDays
}

func addPantryItemsToShoppingList(_ pantryItems: [PantryItem]) {
    let activeListID = SQLiteDB.instance.getActiveListID()
    let date = Date()
//    var insertSuccess = Int64(-1)
//    var updateSuccess = Int64(-2)
//    var toggleSuccess = Int64(-3)
    
    for item in pantryItems {
        let relevantItem = SQLiteDB.instance.getShoppingItemByName(listID: activeListID!, name: item.name)
        if(relevantItem.listID == -1) {
            var itemGroup = Constants.PantryOther
            for item in pantryItems {
                if(item.group != "") {
                    itemGroup = item.group
                }
            }
            _ = SQLiteDB.instance.insertNewItem(listID: activeListID!, itemName: item.name, itemCost: 0, unit: item.unit, quantity: 0, group: itemGroup, purchased: false, expirationDate: date, repurchase: false)
        } else {
            let shoppingQuantity = relevantItem.quantity
            _ = SQLiteDB.instance.updateItem(listID: activeListID!, itemID: relevantItem.id, itemName: relevantItem.name, itemCost: 0, unit: relevantItem.unit, quantity: shoppingQuantity, group: relevantItem.group, purchased: relevantItem.purchased, expirationDate: relevantItem.expirationDate, repurchase: relevantItem.repurchase)
        }
        
        _ = SQLiteDB.instance.togglePantryItem(pantryId: item.id, current: item.toggle)
    }
    
}
