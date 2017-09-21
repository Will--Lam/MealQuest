//
//  PantryUtility.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

func sortByName(this: PantryItem, that: PantryItem) -> Bool {
    return this.name.lowercased() < that.name.lowercased()
}

func sortByExpiration(this: PantryItem, that: PantryItem) -> Bool {
    return this.expiration < that.expiration
}
