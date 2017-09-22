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
    var primary: String
    var secondary: String
    var tertiary: String
    
    init (id: Int64) {
        recipeID = id
        title = ""
        calories = 0
        servings = 0
        readyTime = 0
        prepTime = 0
        cookTime = 0
        instructions = ""
        primary = ""
        secondary = ""
        tertiary = ""
    }
    
    init(id: Int64, title: String, calories: Int, servings: Double, readyTime: Double, prepTime: Double, cookTime: Double, instructions: String, primary: String, secondary: String, tertiary: String) {
        recipeID = id
        self.title = title
        self.calories = calories
        self.servings = servings
        self.readyTime = readyTime
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.instructions = instructions
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
    }
    
}
