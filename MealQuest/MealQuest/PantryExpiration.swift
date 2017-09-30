//
//  PantryExpiration.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-22.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

class PantryExpiration {
    
    let id: Int64
    var expirationGroup: String
    var expirationDays: Int
    
    init(id: Int64) {
        self.id = id
        expirationGroup = ""
        expirationDays = 0
    }
    
    init(id: Int64, expirationGroup: String, expirationDays: Int) {
        self.id = id
        self.expirationGroup = expirationGroup
        self.expirationDays = expirationDays
    }
}
