//
//  ShoppingItem.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class ShoppingItem: FoodItem, Equatable, Hashable {
    let listID: Int64
    var itemCost: Double
    var purchased: Bool
    var expirationDate: Date
    var repurchase: Bool
    
    override init(id: Int64) {
        listID = -1
        itemCost = 0
        purchased = false
        expirationDate = Date()
        repurchase = false
        super.init(id: id)
    }
    
    init(listID: Int64, itemID: Int64, itemName: String, itemCost: Double, unit: String, quantity: Double, group: String, purchased: Bool, expirationDate: Date, repurchase: Bool) {
        self.listID = listID
        self.itemCost = itemCost
        self.purchased = purchased
        self.expirationDate = expirationDate
        self.repurchase = repurchase
        super.init(id: itemID, name: itemName, group: group, quantity: quantity, unit: unit)
    }
    
    var hashValue: Int {
        get {
            return name.lowercased().hashValue
        }
    }
    
    static func ==(lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        return lhs.name.caseInsensitiveCompare(rhs.name) == ComparisonResult.orderedSame
    }
    
    static func <(lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
    
}
