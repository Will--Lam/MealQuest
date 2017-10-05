//
//  ButtonCell.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var name: UILabel!
//    @IBOutlet var changeUnit: UIButton!
    
    var index = Int()
    var unit = String()
    var quantity = Double()
    var ingredient = String()
    var ingredientsArray = [RecipeIngredient]()
    
    let unitPickerView = UIPickerView()
    var alert = UIAlertController()
    var observer: RecipeViewController!
    /*
    @IBAction func changeUnitClicked(sender: UIButton) {
        //set the pickers datasource and delegate
        self.unitPickerView.delegate = self
        self.unitPickerView.dataSource = self
        
        //1. Create the alert controller.
        self.alert = UIAlertController(title: "Change Unit Type", message: "Enter a new unit and quantity will be adjusted accordingly.", preferredStyle: .alert)
        
        //Add the picker to the alert controller
        self.alert.addTextField { (textField) in
            textField.placeholder = self.unit
            textField.inputView = self.unitPickerView
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        self.alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
            let newUnit = self.alert.textFields?[0].text!
            let newAmount = self.convert(self.quantity, self.unit, newUnit!)
            if (newAmount < 0) {
                self.convertFailedAlert(self.unit, newUnit!)
            } else {
                self.unit = newUnit!
                self.quantity = newAmount
                // TODO: update the label of the cell
                self.name.text = self.quantity.formatString(places: 2) + " " + self.unit + " " + self.ingredient
                self.updateIngredientsTable()
            }
        }))
        
        // Present the alert.
        observer.present(alert, animated: true, completion: nil)
    }
    
    func convertFailedAlert(_ oldUnit: String, _ newUnit: String) {
        //1. Create the alert controller.
        let msg = "Failed to convert unit of type " + oldUnit + " to unit of type " + newUnit
        let alert = UIAlertController(title: "Unit Conversion Failed.", message: msg, preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 4. Present the alert.
        observer.present(alert, animated: true, completion: nil)
    } */
    
    func updateIngredientsTable( ) {
        for (index, item) in ingredientsArray.enumerated() {
            if (index != self.index) {
                ingredientsArray[index].quantity = item.quantity
                ingredientsArray[index].unit = item.unit
                ingredientsArray[index].name = item.name
            }
        }
        
        observer.ingredientsArray = ingredientsArray
        observer.redrawView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alert.textFields?[0].text = Constants.units[row]
    }
    /*
    func convert(_ amount: Double, _ from:String, _ to: String) -> Double {
        
        var fromBase = ""
        var toBase = ""
        do {
            
            for (base, convert) in Constants.localConversionTable{
                
                if convert[from.lowercased()] != nil {
                    fromBase = base
                }
                if convert[to.lowercased()] != nil {
                    toBase = base
                }
            }
            
            guard ((fromBase != "") && (toBase != "")) else {
                throw convertError.failedConversion
            }
            
            if(from.caseInsensitiveCompare(to) == ComparisonResult.orderedSame) {
                return amount
            } else {
                guard (Constants.baseConversionTable[fromBase]![toBase]! != 0) else {
                    throw convertError.failedConversion
                }
                
                // go from local system units to base of that system
                var conversion = amount * Constants.localConversionTable[fromBase]![from.lowercased()]!
                
                // convert form base of one system to base of another
                conversion = conversion * Constants.baseConversionTable[fromBase]![toBase]!
                
                // convert from base of destination system to exact units
                conversion = conversion / Constants.localConversionTable[toBase]![to.lowercased()]!
                
                let rounded = conversion.roundTo(places: 4)
                
                return rounded
            }
        } catch {
            print("Cannot convert from "+from+" to "+to)
            return -1
        }
    }*/
}
