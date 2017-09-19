//
//  ShoppingLists.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class ShoppingLists {
    let listID: Int64
    var listCost: Double
    var listDate: Date
    var isActive: Bool
    
    init(listID: Int64) {
        self.listID = listID
        listCost = 0
        listDate = Date()
        isActive = false
    }
    
    init(listID: Int64, listCost: Double, listDate: Date, isActive: Bool) {
        self.listID = listID
        self.listCost = listCost
        self.listDate = listDate
        self.isActive = isActive
    }
    
    static func >(lhs: ShoppingLists, rhs: ShoppingLists) -> Bool {
        return lhs.listDate > rhs.listDate
    }
    
}
