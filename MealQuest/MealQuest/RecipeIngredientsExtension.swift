//
//  RecipeIngredientsExtension.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-14.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

extension RecipeViewController {
    func setIngredientsView( ) {
        ingredientsView.ingredientsTable.dataSource = self
        ingredientsView.ingredientsTable.delegate = self
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: "ButtonCell", bundle: nil)
        ingredientsView.ingredientsTable.register(cellNib, forCellReuseIdentifier: "ButtonCell")
        
        // Serving size field at the top of the ingredients page
        let string = ("Serving Size: " + "\(servingSize)") as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20.0)])
        
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0)]
        
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Serving Size:"))
        
        ingredientsView.changeServingLabel.attributedText = attributedString
        
        ingredientsView.observer = self
        ingredientsView.servingSize = servingSize
        ingredientsView.ingredientsArray = ingredientsArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
        cell.index = indexPath.item
        cell.ingredientsArray = ingredientsArray
        
        cell.unit = self.ingredientsArray[indexPath.item].unit
        cell.quantity = self.ingredientsArray[indexPath.item].quantity
        cell.ingredient = self.ingredientsArray[indexPath.item].name
        cell.observer = self
        
        cell.name.text = cell.quantity.formatString(places: 2) + " " + cell.unit + " " + cell.ingredient
        
        return cell;
        
    }
}
