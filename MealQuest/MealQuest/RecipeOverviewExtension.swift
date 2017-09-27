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
        overviewView.categoryImage.image = UIImage(named: Constants.recipeIconMap[primary]!)
        
        if (recipeDetails.imagePath == "") {
            overviewView.recipeImage.image = UIImage(named: "imageNotFound")
        } else {
            let fileManager = FileManager.default
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(recipeDetails.imagePath)
            if fileManager.fileExists(atPath: imagePAth){
                overviewView.recipeImage.image = UIImage(contentsOfFile: imagePAth)
            }else{
                print("No Image")
                overviewView.recipeImage.image = UIImage(named: "imageNotFound")
            }
        }
        
        images = []
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectoryPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectoryPath.appending("/RecipeImages")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false {
            do {
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Something went wrong")
            }
        }
        
        overviewView.observer = self
        
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            overviewView.imagePicked.contentMode = .scaleAspectFit
            overviewView.imagePicked.image = pickedImage
            overviewView.recipeImage.image = overviewView.imagePicked.image
            print("WORKING")
            
            var imagePath = NSDate().description
            imagePath = imagePath.replacingOccurrences(of: " ", with: "")
            imagePath = imagesDirectoryPath.appending("/\(imagePath).png")
            let data = UIImagePNGRepresentation(overviewView.recipeImage.image!)
            let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
            
            if (!success) {
                print("error")
            }
            
            // Update the database that the image has been saved successfully
            recipeDetails.imagePath = imagePath
//**        Need response from the update
            var response = -1
            updateRecipe(recipeItem: recipeDetails)
            response = 1
            if (response != -1) {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "New recipe image has been successfully saved.", message: "", preferredStyle: .alert)
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
