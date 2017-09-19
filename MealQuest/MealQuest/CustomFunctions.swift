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
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var expired = false
    
    var relativeDate = ""
    
    let dateFormatter = DateFormatter()
    
    let today = Date();
    dateFormatter.dateFormat = "y"
    let curYear = Int(dateFormatter.string(from: today))!
    let itemYear = Int(dateFormatter.string(from: date))!
    dateFormatter.dateFormat = "M"
    let curMonth = Int(dateFormatter.string(from: today))!
    let itemMonth = Int(dateFormatter.string(from: date))!
    dateFormatter.dateFormat = "dd"
    let curDay = Int(dateFormatter.string(from: today))!
    let itemDay = Int(dateFormatter.string(from: date))!

    var relativeYear = itemYear - curYear
    var relativeMonth = itemMonth - curMonth
    var relativeDay = itemDay - curDay
    
    if ((relativeYear < 0) || (relativeMonth < 0) || (relativeDay < 0)) {
        expired = true
        
        if (relativeYear < 0) {
            if ((relativeDay < 0) && (relativeMonth < 0)) {
                relativeYear = abs(relativeYear)
                relativeMonth = abs(relativeMonth)
                relativeDay = abs(relativeDay)
            } else if (relativeMonth < 0) {
                relativeYear = abs(relativeYear)
                relativeMonth = abs(relativeMonth + 1)
                relativeDay = daysInMonth[curMonth - 1] - itemDay + curDay
            } else if ((relativeDay > 0) && (relativeMonth == 0)) {
                relativeYear = abs(relativeYear + 1)
                relativeMonth = relativeMonth + 11
                relativeDay = daysInMonth[curMonth - 1] - itemDay + curDay
            } else if ((relativeDay < 0) && (relativeMonth == 0)) {
                relativeYear = abs(relativeYear)
                relativeDay = abs(relativeDay)
            } else if (relativeDay < 0) {
                relativeYear = abs(relativeYear + 1)
                relativeMonth = abs(relativeMonth - 12)
                relativeDay = abs(relativeDay)
            } else {
                relativeYear = abs(relativeYear + 1)
                relativeMonth = abs(relativeMonth - 12) - 1
                relativeDay = daysInMonth[curMonth - 2] - itemDay + curDay
            }
        } else if (relativeMonth < 0) {
            if (relativeDay > 0) {
                relativeDay = daysInMonth[itemMonth - 1] - itemDay + curDay
                relativeMonth = abs(relativeMonth + 1)
            } else {
                relativeMonth = abs(relativeMonth)
                relativeMonth = abs(relativeDay)
            }
        } else {
            relativeDay = abs(relativeDay)
        }
    }
    
    if (relativeYear == 1) {
        relativeDate = String(relativeYear) + " year"
    } else if (relativeYear > 1) {
        relativeDate = String(relativeYear) + " years"
    }
    
    if (relativeDate == "") {
        if (relativeMonth == 1) {
            relativeDate = String(relativeMonth) + " month"
        } else if (relativeMonth > 1) {
            relativeDate = String(relativeMonth) + " months"
        }
    } else {
        if (relativeMonth == 1) {
            relativeDate = relativeDate + ", " + String(relativeMonth) + " month"
        } else if (relativeMonth > 1) {
            relativeDate = relativeDate + ", " + String(relativeMonth) + " months"
        }
    }
    
    if (relativeDate == "") {
        if (relativeDay == 1) {
            relativeDate = String(relativeDay) + " day"
        } else if (relativeDay > 1) {
            relativeDate = String(relativeDay) + " days"
        }
    } else {
        if (relativeDay == 1) {
            relativeDate = relativeDate + ", " + String(relativeDay) + " day"
        } else if (relativeDay > 1) {
            relativeDate = relativeDate + ", " + String(relativeDay) + " days"
        }
    }
    
    if (relativeDate == "") {
        relativeDate = "0 days"
    }

    if (expired) {
        return relativeDate + " expired."
    } else {
        return relativeDate + " till expiration."
    }
}
