//
//  Constants.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-06-29.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

struct Constants {
    // constants for Unit
    public static let UnitML = "ML"
    public static let UnitKG = "KG"
    public static let UnitLB = "LB"
    
    // constants for Group
    public static let PantryAll = "All"
    public static let PantryDairy = "Dairy"
    public static let PantryProteins = "Proteins"
    public static let PantryVeggies = "Fruits and Veggies"
    public static let PantryBakery = "Wheat and Bakery"
    public static let PantryOther = "Other Grocery"
    
    // constants for Trophies
    public static let TrophyPlatinum = "platinumTrophy"
    public static let TrophyGold = "goldTrophy"
    public static let TrophySilver = "silverTrophy"
    public static let TrophyBronze = "bronzeTrophy"
    
    // callories required per day
    public static let caloriesRequired: Double = 2000
    
    // constant for rounding
    public static let roundingPlaces = 5
    
    public static let groups = ["Dairy", "Proteins", "Fruits and Veggies", "Wheat and Bakery", "Other Grocery"]
    public static let units = ["mg", "g", "kg", "tsp", "tbsp", "lb", "ton", "oz", "pt", "gal", "ml", "l", "kl", "cup"]
    public static let weightUnit = ["kg", "lb"]
    public static let heightUnit = ["cm", "in"]
    public static let gender = ["Male", "Female", "Other"]
    public static let activityLevel = ["Low", "Medium", "High"]
    
    // Time in Seconds
    public static let dayInSeconds = 86400.0
    
    public static let mqWhiteColour = UIColor(red: 239.0/255.0, green: 248.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    public static let mqBlueColour = UIColor(red: 112.0/255.0, green: 208.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    public static let mqGreyColour = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 1.0)

    // conversion standards
    public static let localConversionTable: [String:[String:Double]] = [
        "g": [
            "mg": 0.001,
            "g": 1,
            "kg": 1000,
        ],
        
        "tsp": [
            "tsp": 1,
            "tbsp": 3,
        ],
        
        "lb": [
            "lb": 1,
            "ton": 2240
        ],
        
        "oz": [
            "oz": 1,
            "pt": 20,
            "gal": 160,
        ],
        
        "l": [
            "ml": 0.001,
            "l": 1,
            "kl": 1000
        ],
        
        "cup": [
            "cup": 1,
        ],
        
        "cm": [
            "cm": 1,
        ],
        
        "in": [
            "in": 1,
        ],
    ]
    
    public static let servingConversionTable: [String:[String:Double]] = [
        // Dairy
        Constants.groups[0]: [
            "g": 1000,
            "tsp": 202.884,
            "oz": 33.814,
            "lb": 2.2046,
            "cup": 4.22675,
            "l": 1,
        ],
        // Proteins
        Constants.groups[1]: [
            "l": 0.001,
            "g": 1,
            "lb": 0.00220462,
            "oz": 0.035274,
            "tsp": 0.2,
            "cup": 0.00422675281986,
        ],
        // Fruits and Veggies
        Constants.groups[2]: [
            "g": 5,
            "oz": 1,
            "l": 0.0295735,
            "tsp": 2,
            "cup": 0.125,
        ],
        // Wheat and Bakery
        Constants.groups[3]: [
            "tsp": 1,
            "l": 0.00492892,
            "oz": 0.5,
            "g": 5,
            "cup": 0.0208333
        ]
    ]
    
    public static let baseConversionTable: [String:[String:Double]] = [
        "l": [
            "g": 1000,
            "tsp": 202.884,
            "oz": 33.814,
            "lb": 2.2046,
            "cup": 4.22675,
            "l": 1,
        ],
        "g": [
            "l": 0.001,
            "g": 1,
            "lb": 0.00220462,
            "oz": 0.035274,
            "tsp": 0.2,
            "cup": 0.00422675281986,
        ],
        "oz": [
            "g": 5,
            "oz": 1,
            "l": 0.0295735,
            "tsp": 2,
            "cup": 0.125,
            "lb": 0.0625,
        ],
        "tsp": [
            "tsp": 1,
            "l": 0.00492892,
            "oz": 0.5,
            "g": 5,
            "cup": 0.0208333,
            "lb": 0.013
        ],
        "lb": [
            "g": 453.592,
            "lb": 1,
            "l": 0.4536,
            "tsp": 79.75,
            "cup": 1.91722,
            "oz": 16
        ],
        "cup": [
            "g": 340,
            "cup": 1,
            "l": 0.236588,
            "tsp": 48,
            "oz": 8,
            "lb": 0.52159
        ],
        "cm": [
            "cm": 1,
            "in": 0.393701,
        ],
        "in": [
            "in": 1,
            "cm": 2.54,
        ]
    ]
    
    // Challenges
    
    public static let skills = ["Bake", "Boil", "Chop", "Cut", "Dice", "Fillet", "Fry", "Grill", "Mince", "Mix", "Peel", "Roast", "Sauté", "Simmer", "Slice", "Steam", "Toast", "Whisk"]
    
    public static let trophies = ["bronzeTrophy", "silverTrophy", "goldTrophy", "platinumTrophy"]

    public static let itemNames = ["water"]
    
    public static let xpIncreaseForApplySkill = 50

    // User EXP
    public static let levelBase = 1.05809
    public static let levelMultiplier = 200
    
    // Recommended Calories
    public static let PACoefficient = 1.25
    
}

