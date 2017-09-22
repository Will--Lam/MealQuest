//
//  PantryRequestHandler.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

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
    
    items.sort(by: sortByName)
    
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
