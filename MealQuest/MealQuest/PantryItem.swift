//
//  PantryItem.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-06-30.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class PantryItem: FoodItem, Hashable {
    var calories: Int
    var isArchive: Int
    var expiration: Date
    var purchase: Date
    var archive: Date
    var toggle: Int
    var search: Int

    override init(id: Int64) {
        calories = 0
        isArchive = 0
        expiration = Date()
        purchase = Date()
        archive = Date()
        toggle = 0
        search = 0
        super.init(id: id)
    }
    
    init(id: Int64, name: String, group: String, quantity: Double, unit: String, calories: Int, isArchive: Int, expiration: Date, purchase: Date, archive: Date, toggle: Int, search: Int) {
        
        self.calories = calories
        self.isArchive = isArchive
        self.expiration = expiration
        self.purchase = purchase
        self.archive = archive
        self.toggle = toggle
        self.search = search
        super.init(id: id, name: name, group: group, quantity: quantity, unit: unit)
    }
    
    var hashValue: Int {
        get {
            return name.lowercased().hashValue
        }
    }
    
    static func ==(lhs: PantryItem, rhs: PantryItem) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    static func <(lhs: PantryItem, rhs: PantryItem) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
}
