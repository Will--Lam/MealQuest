//
//  CustomFunctions.swift
//  MealQuest
//
//  Created by Will Lam on 2017-08-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

// Note: The date being passed is assumed to be in the future compared to the current day
func getRelativeDate(date: Date) -> String {
    
    let now = Date()
    let endDate = date
    
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .month, .year]
    formatter.unitsStyle = .full
    let string = formatter.string(from: now, to: endDate)!
    
    print(string) // 2 weeks, 3 days
    
    let negChar = string.substring(to:string.index(string.startIndex, offsetBy: 1))
    
    if (negChar == "-") {
        let relativeDate = string.substring(from: string.index(string.startIndex, offsetBy: 1, limitedBy: string.endIndex)!)
        return relativeDate + " expired."
    } else {
        return string + " until expiration."
    }
    
}
