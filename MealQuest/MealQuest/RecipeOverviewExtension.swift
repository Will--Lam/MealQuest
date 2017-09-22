//
//  RecipeOverviewExtension.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

extension RecipeViewController {
    func setOverviewView( ) {
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        /*
        self.navigationItem.title = recipeDetails["title"] as? String
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        let titleText = recipeDetails["title"] as! String
        let calorieText = recipeDetails["calorie"] as! String
        let imageURL = recipeDetails["imageURL"] as! String
        let servingSizeText = recipeDetails["servings"] as! String
        servingSize = Int(servingSizeText)!
        let totalTime = recipeDetails["readyInMinutes"] as! String
        let cookTime = recipeDetails["cookingMinutes"] as! String
        let prepTime = recipeDetails["preparationMinutes"] as! String
        let healthScore = recipeDetails["healthScore"] as! String*/
        
        var imageRendered = false
        overviewView.recipeImage.contentMode = .scaleAspectFit
            
        /* overviewView.titleLabel.text = titleText
        overviewView.titleLabel.adjustsFontSizeToFitWidth = true
        overviewView.calorieLabel.text = "Calories/Serving " + calorieText
        overviewView.totalTimeLabel.text = "Total Time: " + totalTime
        overviewView.prepTimeLabel.text = "Prep Time: " + prepTime
        overviewView.cookTimeLabel.text = "Cook Time: " + cookTime
        overviewView.healthScoreLabel.text = healthScore
        
        overviewView.servingSizeLabel.text = "Serving Size: " + "\(servingSize)"
        */
        overviewView.observer = self
        
    }
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            overviewView.imagePicked.contentMode = .scaleAspectFit
            overviewView.imagePicked.image = pickedImage
            overviewView.recipeImage.image = overviewView.imagePicked.image
            print("WORKING")
            
            // let imageData = UIImageJPEGRepresentation(overviewView.imagePicked.image!, 0.6)
            // let compressedJPGImage = UIImage(data: imageData!)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            // print("image saved")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
