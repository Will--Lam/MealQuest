//
//  RecipeInstructionExtension.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

extension RecipeViewController {
    func setInstructionsView( ) {
        /*let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0)]
            
        let tempArray = recipeDetails["analyzedInstructions"] as? String
        let itemArray = tempArray?.components(separatedBy: "|")
        var string = String()
        var stepCount = 0
        for (index,step) in (itemArray?.enumerated())! {
            if ((index % 2) == 1) {
                string += step + "\n\n"
            } else {
                string += "Step " + step + ":\n"
                stepCount += 1
            }
        }
            
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20.0)])
        for i in 1...stepCount {
            let subString = "Step " + "\(i)" + ":"
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: subString))
        }
            
        instructionsView.instructionLabel.attributedText = attributedString
            
        instructionsView.instructionLabel.isEditable = false*/
    }
}
