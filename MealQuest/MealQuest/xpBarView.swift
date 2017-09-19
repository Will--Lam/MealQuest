//
//  xpBarView.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class xpBarView: UIView {

    var curVal: Double!
    var reqVal: Double!
    
    override func draw(_ rect: CGRect) {
        
        // 2. Draw the foreground bar
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        
        // 3. Close the path
        Constants.mqGreyColour.setFill()
        backgroundPath.fill()
        
        // 1. Calculate the length per xp
        let lengthPerXP = bounds.width / CGFloat(reqVal)
        
        // then multiply out by the actual xp
        let foregroundXP = lengthPerXP * CGFloat(curVal)
        
        // 2. Draw the foreground bar
        let foregroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: foregroundXP, height: bounds.height))
        
        // 3. Close the path
        Constants.mqBlueColour.setFill()
        foregroundPath.fill()
    }

}
