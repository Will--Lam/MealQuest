//
//  OverviewView.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-07.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class OverviewView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var primaryCategoryLabel: UILabel!
    @IBOutlet weak var secondaryCategoryLabel: UILabel!
    @IBOutlet weak var tertiaryCategoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var imagePicked = UIImageView()
    let imagePicker = UIImagePickerController()
    
    var observer: RecipeViewController!
    
    @IBAction func setRecipeImageAction(_ sender: Any) {
        print("Hello")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.delegate = observer
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
            observer.present(imagePicker, animated: true, completion: nil)
        } else {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Please grant permission to the app to have ability to edit recipe image.", message: "", preferredStyle: .alert)
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // 4. Present the alert.
            observer.present(alert, animated: true, completion: nil)
        }
    }
    
}
