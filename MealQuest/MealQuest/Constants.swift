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
    
    // constants for Pantry
    public static let PantryAll = "All Items"
    public static let PantryDairy = "Dairy"
    public static let PantryProteins = "Proteins"
    public static let PantryVeggies = "Fruits & Veggies"
    public static let PantryBakery = "Wheat & Bakery"
    public static let PantryOther = "Other Grocery"
    public static let PantryBakingGood = "Baking Goods"
    public static let PantryFrozen = "Frozen"
    public static let PantryNonPerish = "Non-perishables"
    public static let PantryHousehold = "Household"
    public static let PantryPasta = "Pasta & Rice"
    public static let PantryCondiment = "Condiments"
    public static let PantrySnacks = "Snacks"
    public static let PantryOil = "Oils & Vinegar"
    public static let PantryDrinks = "Drinks"
    public static let PantrySpreads = "Spreads"
    
    public static let pantryGroups = [
        Constants.PantryAll,
        Constants.PantryDairy,
        Constants.PantryProteins,
        Constants.PantryVeggies,
        Constants.PantryBakery,
        Constants.PantryOther,
        Constants.PantryBakingGood,
        Constants.PantryFrozen,
        Constants.PantryNonPerish,
        Constants.PantryHousehold,
        Constants.PantryPasta,
        Constants.PantryCondiment,
        Constants.PantrySnacks,
        Constants.PantryOil,
        Constants.PantryDrinks,
        Constants.PantrySpreads,]
    
    public static let pantryIconMap : [String: String] = [
        Constants.PantryAll: "allCategory",
        Constants.PantryDairy: "dairyCategory",
        Constants.PantryProteins: "proteinCategory",
        Constants.PantryVeggies: "veggieCategory",
        Constants.PantryBakery: "bakeryCategory",
        Constants.PantryOther: "otherCategory",
        Constants.PantryBakingGood: "bakingCategory",
        Constants.PantryFrozen: "freezerCategory",
        Constants.PantryNonPerish: "nonPerishCategory",
        Constants.PantryHousehold: "householdCategory",
        Constants.PantryPasta: "pastaCategory",
        Constants.PantryCondiment: "condimentCategory",
        Constants.PantrySnacks: "snackCategory",
        Constants.PantryOil: "oilCategory",
        Constants.PantryDrinks: "drinkCategory",
        Constants.PantrySpreads: "spreadCategory"]
    
    // constants for Recipe
    public static let RecipeAll = "All"
    public static let RecipeBreakfast = "Breakfast"
    public static let RecipeLunch = "Lunch"
    public static let RecipeBeverage = "Beverage"
    public static let RecipeAppetizer = "Appetizers"
    public static let RecipeSnacks = "Snacks"
    public static let RecipeSoups = "Soups"
    public static let RecipeSalads = "Salads"
    public static let RecipeBeef = "Beef Entree"
    public static let RecipeChicken = "Poultry Entree"
    public static let RecipePork = "Pork Entree"
    public static let RecipeSeafood = "Seafood Entree"
    public static let RecipeVegetarian = "Vegetarian Entree"
    public static let RecipeVeggie = "Vegetable Entree"
    public static let RecipeOther = "Other"
    public static let RecipeDesserts = "Desserts"
    public static let RecipeCan = "Canning/Freezing"
    public static let RecipeBreads = "Breads"
    public static let RecipeHolidays = "Holidays"
    public static let RecipeEntertaining = "Entertaining"
    
    public static let recipeGroups = [Constants.RecipeBreakfast, Constants.RecipeLunch, Constants.RecipeBeverage, Constants.RecipeAppetizer, Constants.RecipeSnacks, Constants.RecipeSoups, Constants.RecipeSalads, Constants.RecipeBeef, Constants.RecipeChicken, Constants.RecipePork, Constants.RecipeSeafood, Constants.RecipeVegetarian, Constants.RecipeVeggie, Constants.RecipeOther, Constants.RecipeDesserts, Constants.RecipeCan, Constants.RecipeBreads, Constants.RecipeHolidays, Constants.RecipeEntertaining]
    
    // constant for rounding
    public static let roundingPlaces = 5
    
    public static let units = ["mg", "g", "kg", "tsp", "tbsp", "lb", "ton", "oz", "pt", "gal", "ml", "l", "kl", "cup"]
    
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
    
}

