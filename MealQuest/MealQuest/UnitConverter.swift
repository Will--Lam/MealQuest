//
//  UnitConverter.swift
//  MealQuest
//
//  Created by Kushal Kumarasinghe on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

/* These are the measurements we can convert with
 miligrams: ml
 grams: g
 kilograms: kg
 
 teaspoon: tsp
 tablespoon: tbsp
 
 pounds: lb
 tons: ton
 
 ounces: oz
 pints: pt
 gallons: gal
 
 mililitres: ml
 litres: l
 kilolitres: kl
 
 cups: cup
 
 FOR HEIGHT:
 inches: in
 centimetres: cm
 
*/

enum convertError: Error {
    case failedConversion
}

func convert(_ amount: Double, _ from:String, _ to: String) -> Double {
    
    var fromBase = ""
    var toBase = ""
    do {
        
        for (base, convert) in Constants.localConversionTable{

            if convert[from.lowercased()] != nil {
                fromBase = base
            }
            if convert[to.lowercased()] != nil {
                toBase = base
            }
        }
    
        guard ((fromBase != "") && (toBase != "")) else {
            throw convertError.failedConversion
        }
    
        if(from.caseInsensitiveCompare(to) == ComparisonResult.orderedSame) {
            return amount
        } else {
            guard (Constants.baseConversionTable[fromBase]![toBase]! != 0) else {
                throw convertError.failedConversion
            }
            
            // go from local system units to base of that system
            var conversion = amount * Constants.localConversionTable[fromBase]![from.lowercased()]!
    
            // convert form base of one system to base of another
            conversion = conversion * Constants.baseConversionTable[fromBase]![toBase]!
    
            // convert from base of destination system to exact units
            conversion = conversion / Constants.localConversionTable[toBase]![to.lowercased()]!
    
            let rounded = conversion.roundTo(places: 4)
            
            return rounded
        }
    } catch {
        print("Cannot convert from "+from+" to "+to)
        return -1
    }
}
