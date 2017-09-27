//
//  ShoppingCompareViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-16.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingCompareViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var item1Name: UITextField!
    @IBOutlet weak var item1Quantity: UITextField!
    @IBOutlet weak var item1Unit: UITextField!
    @IBOutlet weak var item1Cost: UITextField!
    @IBOutlet weak var item1ValueLabel: UILabel!
    @IBOutlet weak var item1Button: UIButton!
    
    var item1UnitPickerView = UIPickerView()
    var unit1Selected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    
    @IBOutlet weak var item2Name: UITextField!
    @IBOutlet weak var item2Quantity: UITextField!
    @IBOutlet weak var item2Unit: UITextField!
    @IBOutlet weak var item2Cost: UITextField!
    @IBOutlet weak var item2ValueLabel: UILabel!
    @IBOutlet weak var item2Button: UIButton!
    
    var item2UnitPickerView = UIPickerView()
    var unit2Selected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    
    @IBOutlet weak var historicBestValue: UILabel!
    
    var purchasedState = false
    var expirationDate = Date()
    var observer: Observer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        item1UnitPickerView.delegate = self
        item1UnitPickerView.tag = 1
        item1Unit.inputView = item1UnitPickerView
        item1Unit.text = Constants.units[0]
        
        item2UnitPickerView.delegate = self
        item2UnitPickerView.tag = 2
        item2Unit.inputView = item2UnitPickerView
        item2Unit.text = Constants.units[0]
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return Constants.units[row]
        } else if (pickerView.tag == 2) {
            return Constants.units[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            item1Unit.text = Constants.units[row]
            UserDefaults.standard.set(Constants.validPantryGroups[row], forKey: "unit1Selected")
        } else if (pickerView.tag == 2) {
            item2Unit.text = Constants.units[row]
            UserDefaults.standard.set(Constants.validPantryGroups[row], forKey: "unit2Selected")
        }
    }
    
    func checkItem1Value( ) {
        let cost = item1Cost.text!
        let quantity = item1Quantity.text!
        let unit = item1Unit.text!
        
        if ((cost != "") && (quantity != "") && (unit != "")) {
            let perG = convert(Double(quantity)!, unit, "g")
            let value = (Double(cost)! / perG) * 100
            
            item1ValueLabel.text = "$" + value.formatString(places: 2)
        }
    }
    
    @IBAction func checkItem1FromQuantity(_ sender: Any) {
        checkItem1Value()
    }
    
    @IBAction func checkItem1FromUnit(_ sender: Any) {
        checkItem1Value()
    }
    
    @IBAction func checkItem1FromCost(_ sender: Any) {
        checkItem1Value()
    }
    
    func checkItem2Value ( ) {
        let cost = item2Cost.text!
        let quantity = item2Quantity.text!
        let unit = item2Unit.text!

        if ((cost != "") && (quantity != "") && (unit != "")) {
            let perG = convert(Double(quantity)!, unit, "g")
            let value = (Double(cost)! / perG) * 100
            
            item2ValueLabel.text = "$" + value.formatString(places: 2)
        }
    }
    
    @IBAction func checkItem2FromQuantity(_ sender: Any) {
        checkItem2Value()
    }
    
    @IBAction func checkItem2FromUnit(_ sender: Any) {
        checkItem2Value()
    }
    
    @IBAction func checkItem2FromCost(_ sender: Any) {
        checkItem2Value()
    }
    
    @IBAction func updateBestHistoricCost(_ sender: Any) {
        
        let name = item1Name.text!
        let historicItems = getAllShoppingItems()
        
        var foundItem = ShoppingItem(id: Int64(-1))
        for item in historicItems {
            if (item.name.lowercased() == name.lowercased()) {
                foundItem = item
            }
        }
        
        if (foundItem.listID != Int64(-1)) {
            let cost = foundItem.itemCost
            let quantity = foundItem.quantity
            let unit = foundItem.unit
            
            let perG = convert(quantity, unit, "g")
            let value = (cost / perG) * 100
            
            historicBestValue.text = "$" + value.formatString(places: 2)
        } else {
            historicBestValue.text = "N/A"
        }
    }

    @IBAction func selectItem1Action(_ sender: Any) {
        let name = item1Name.text!
        let cost = item1Cost.text!
        let quantity = item1Quantity.text!
        let unit = item1Unit.text!
        let group = "Other Grocery"
        if ((name != "") && (cost != "") && (quantity != "") && (group != "") && (unit != "")) {
            
            let newDetails = ShoppingItem(
                listID: -1,
                itemID: -1,
                itemName: name,
                itemCost: Double(cost)!,
                unit: unit,
                quantity: Double(quantity)!,
                group: group,
                purchased: purchasedState,
                expirationDate: expirationDate,
                repurchase: false
            )
            
            saveNewShoppingItem(newDetails)
            print("Saving edits to database!")
            
            observer.redrawTable()
            
            self.navigationController?.popViewController(animated: true)
        } else {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Required fields were missing. Please review and fill in all required fields.", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectItem2Action(_ sender: Any) {
        let name = item2Name.text!
        let cost = item2Cost.text!
        let quantity = item2Quantity.text!
        let unit = item2Unit.text!
        let group = "Other Grocery"
        if ((name != "") && (cost != "") && (quantity != "") && (group != "") && (unit != "")) {
            
            let newDetails = ShoppingItem(
                listID: -1,
                itemID: -1,
                itemName: name,
                itemCost: Double(cost)!,
                unit: unit,
                quantity: Double(quantity)!,
                group: group,
                purchased: purchasedState,
                expirationDate: expirationDate,
                repurchase: false
            )
            
            saveNewShoppingItem(newDetails)
            print("Saving edits to database!")
            
            observer.redrawTable()
            
            self.navigationController?.popViewController(animated: true)
        } else {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Required fields were missing. Please review and fill in all required fields.", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
}
