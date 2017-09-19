//
//  xpArcView.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-12.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class xpCircleView: UIView {

    let π: CGFloat = CGFloat(Double.pi)
    
    var curVal: Double!
    var reqVal: Double!
    var thickness: CGFloat = 13
    
    override func draw(_ rect: CGRect) {
        // Draw the background of the xpCircle
        // 1. Define the center point of the view where you’ll rotate the arc around.
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2. Calculate the radius based on the max dimension of the view.
        let radius: CGFloat = max(bounds.width - (thickness/2), bounds.height - (thickness/2))
        
        // 3. Define the thickness of the arc.
        let arcWidth = thickness
        
        // 4. Define the start and end angles for the arc.
        let startAngle: CGFloat = -π / 2
        let endAngle: CGFloat = 3 * π / 2
        
        // 5. Create a path based on the center point, radius, and angles you just defined.
        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 6. Set the line width and color before finally stroking the path.
        backgroundPath.lineWidth = thickness
        Constants.mqGreyColour.setStroke()
        backgroundPath.stroke()
        
        // Draw the foreground of the xpCircle
        // 1. Calculate the arc per xp
        let arcLengthPerXP = 2 * π / CGFloat(reqVal)
        
        //then multiply out by the actual xp
        let foregroundEndAngle = arcLengthPerXP * CGFloat(curVal) + startAngle
        
        //2. draw the outer arc
        let foregroundPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: foregroundEndAngle, clockwise: true)
        
        //4 - close the path
        foregroundPath.lineWidth = thickness
        Constants.mqBlueColour.setStroke()
        foregroundPath.stroke()
    }

}
