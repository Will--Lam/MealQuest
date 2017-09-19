//
//  FoodItem.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-07-11.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class FoodItem {
    let id: Int64
    var name: String
    var group: String
    var quantity: Double
    var unit: String
    
    init(id: Int64) {
        self.id = id
        name = ""
        group = ""
        quantity = 0
        unit = ""
    }
    
    init(id: Int64, name: String, group: String, quantity: Double, unit: String) {
        self.id = id
        self.name = name
        self.group = group
        self.quantity = quantity
        self.unit = unit
    }
}
