//
//  RecipeItem.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-22.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class RecipeItem {
    let recipeID: Int64
    var title: String
    var calories: Int
    var servings: Double
    var readyTime: Double
    var prepTime: Double
    var cookTime: Double
    var instructions: String
    
    init (id: Int64) {
        recipeID = id
        self.title = ""
        self.calories = 0
        self.servings = 0
        self.readyTime = 0
        self.prepTime = 0
        self.cookTime = 0
        self.instructions = ""
    }
    
    init(id: Int64, title: String, calories: Int, servings: Double, readyTime: Double, prepTime: Double, cookTime: Double, instructions: String) {
        recipeID = id
        self.title = title
        self.calories = calories
        self.servings = servings
        self.readyTime = readyTime
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.instructions = instructions
    }
    
}
