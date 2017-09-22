//
//  RecipeIngredient.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-22.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class RecipeIngredient {
    let ingredientID: Int64
    var recipeID: Int64
    var name: String
    var unit: String
    var quantity: Double
    
    init(id: Int64) {
        ingredientID = id
        recipeID = 0
        name = ""
        unit = ""
        quantity = 0
    }
    
    init(id: Int64, recipeID: Int64, name: String, unit: String, quantity: Double) {
        ingredientID = id
        self.recipeID = recipeID
        self.name = name
        self.unit = unit
        self.quantity = quantity
    }
}
