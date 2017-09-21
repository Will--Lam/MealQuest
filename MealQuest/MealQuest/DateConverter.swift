//
//  DateConverter.swift
//  MealQuest
//
//  Created by Gergely Szabo on 2017-09-20.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

// ensure date conversion does not throw errors due to empty string
func convertDate(dateString: String) -> Date? {
    var date: Date?
    date = nil
    
    if (dateString != "") {
        date = Date.fromDatatypeValue(dateString)
    }
    
    return date
}
