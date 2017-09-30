//
//  RecipeUtility.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-30.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

func sortByTitle(this: RecipeItem, that: RecipeItem) -> Bool {
    return this.title.lowercased() < that.title.lowercased()
}
