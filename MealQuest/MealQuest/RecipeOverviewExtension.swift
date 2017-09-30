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
        overviewView.calorieLabel.text = "Calories: " + "\(calorieVal)"
        var hours = ceil(totalTime/60)
        var minute = totalTime.truncatingRemainder(dividingBy: 60)
        overviewView.totalTimeLabel.text = "Total Time: " + "\(hours) hour(s)" + " \(minute) minute(s)"
        hours = ceil(prepTime/60)
        minute = prepTime.truncatingRemainder(dividingBy: 60)
        overviewView.prepTimeLabel.text = "Prep Time: " + "\(hours) hour(s)" + " \(minute) minute(s)"
        hours = ceil(cookTime/60)
        minute = cookTime.truncatingRemainder(dividingBy: 60)
        overviewView.cookTimeLabel.text = "Cook Time: " + "\(hours) hour(s)" + " \(minute) minute(s)"
        overviewView.servingSizeLabel.text = "Serving Size: " + "\(servingSize)"
        overviewView.primaryCategoryLabel.text = "Primary Category: " + primary
        overviewView.secondaryCategoryLabel.text = "Secondary Category: " + secondary
        overviewView.tertiaryCategoryLabel.text = "Tertiary Category: " + tertiary
        overviewView.categoryImage.image = UIImage(named: Constants.recipeIconMap[primary]!)
        
        // 9DE8B21A-3E0E-4DDE-8D25-35674D2F6F0B
        
        // /var/mobile/Containers/Data/Application/9AF5E9BF-A718-4F60-A098-3FA8F315C5D3/Documents/RecipeImages/2017-09-2902:59:25+0000.png
        // /var/mobile/Containers/Data/Application/9AF5E9BF-A718-4F60-A098-3FA8F315C5D3/Documents/RecipeImages/2017-09-2902:59:25+0000.png
        
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectoryPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectoryPath.appending("/RecipeImages")
        if (recipeDetails.imagePath == "") {
            overviewView.recipeImage.image = UIImage(named: "imageNotFound")
        } else {
            let imagePath = imagesDirectoryPath.appending(recipeDetails.imagePath)
            print(imagePath)
            if fileManager.fileExists(atPath: imagePath) {
                overviewView.recipeImage.image = UIImage(contentsOfFile: imagePath)
            } else {
                print("No Image")
                overviewView.recipeImage.image = UIImage(named: "imageNotFound")
            }
        }
        
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
            let newImagePath = "/\(imagePath).jpeg"
            imagePath = imagesDirectoryPath.appending("/\(imagePath).jpeg")
            let data = UIImageJPEGRepresentation(overviewView.recipeImage.image!, 0.25)
            let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
            
            if (!success) {
                print("error")
            }
            
            let oldImagePath = recipeDetails.imagePath
            // Update the database that the image has been saved successfully
            print(recipeDetails.imagePath)
            recipeDetails.imagePath = newImagePath
            print(recipeDetails.imagePath)
//**        Need response from the update
            var response = -1
            updateRecipe(recipeItem: recipeDetails)
            print(recipeDetails.imagePath)
            
            if (oldImagePath != "") {
                do {
                    let imagePath = imagesDirectoryPath.appending(oldImagePath)
                    print(imagePath)
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            }
            
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
