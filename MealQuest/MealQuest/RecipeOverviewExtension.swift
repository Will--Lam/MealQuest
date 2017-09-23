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
        
        self.navigationItem.title = recipeDetails.title
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        let titleText = recipeDetails.title
        let calorieVal = recipeDetails.calories
        servingSize = recipeDetails.servings
        let totalTime = recipeDetails.readyTime
        let cookTime = recipeDetails.cookTime
        let prepTime = recipeDetails.prepTime
        let primary = recipeDetails.primary
        let secondary = recipeDetails.secondary
        let tertiary = recipeDetails.tertiary
        
        overviewView.recipeImage.image = UIImage(named: Constants.recipeIconMap[primary]!)
        overviewView.titleLabel.text = titleText
        overviewView.titleLabel.adjustsFontSizeToFitWidth = true
        overviewView.calorieLabel.text = "Calories/Serving: " + "\(calorieVal)"
        overviewView.totalTimeLabel.text = "Total Time: " + "\(totalTime)"
        overviewView.prepTimeLabel.text = "Prep Time: " + "\(prepTime)"
        overviewView.cookTimeLabel.text = "Cook Time: " + "\(cookTime)"
        overviewView.servingSizeLabel.text = "Serving Size: " + "\(servingSize)"
        overviewView.primaryCategoryLabel.text = "Primary Category: " + primary
        overviewView.secondaryCategoryLabel.text = "Secondary Category: " + secondary
        overviewView.tertiaryCategoryLabel.text = "Tertiary Category: " + tertiary
        
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
