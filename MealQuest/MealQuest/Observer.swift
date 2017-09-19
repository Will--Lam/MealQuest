//
//  Observer.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-07.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import Foundation

protocol Observer : class {
    
    // Used to notify observer when to redraw
    func redrawTable( )
    // Used for updating doubles (i.e. cost)
    func updateDouble(_: Double)
    // Used for passing shoppping information
    func populateFields(_: ShoppingItem)
}
