//
//  ShoppingEditItemViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-20.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingEditItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    var cost = Double()
    @IBOutlet weak var groupTextField: UITextField!
    var purchasedState = false
    @IBOutlet weak var expirationTextField: UITextField!
    var expirationDate = Date()
    @IBOutlet weak var saveEditButton: UIBarButtonItem!
    
    var observer: Observer!
    
    let groupPickerView = UIPickerView()
    var groupSelected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    let unitPickerView = UIPickerView()
    var unitSelected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    
    var itemDetails = ShoppingItem(id: -1)
    var id = Int64()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
        
        itemNameTextField.text = itemDetails.name
        costTextField.text = String(format: "%.2f", itemDetails.itemCost)
        quantityTextField.text = "\(itemDetails.quantity)"
        unitTextField.text = "\(itemDetails.unit)"
        groupTextField.text = itemDetails.group
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        expirationTextField.text = dateFormatter.string(from: itemDetails.expirationDate)
        expirationDate = itemDetails.expirationDate
        
        groupPickerView.delegate = self
        groupPickerView.tag = 1
        groupTextField.inputView = groupPickerView
        groupPickerView.selectRow(Constants.validPantryGroups.index(of: groupTextField.text!)!, inComponent:0, animated:true)
        
        unitPickerView.delegate = self
        unitPickerView.tag = 2
        unitTextField.inputView = unitPickerView
        unitPickerView.selectRow(Constants.units.index(of: unitTextField.text!)!, inComponent:0, animated:true)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return Constants.validPantryGroups.count
        } else if (pickerView.tag == 2) {
            return Constants.units.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return Constants.validPantryGroups[row]
        } else if (pickerView.tag == 2) {
            return Constants.units[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            groupTextField.text = Constants.validPantryGroups[row]
            UserDefaults.standard.set(Constants.validPantryGroups[row], forKey: "groupSelected")
        } else if (pickerView.tag == 2) {
            unitTextField.text = Constants.units[row]
            UserDefaults.standard.set(Constants.units[row], forKey: "unitSelected")
        }
    }
    
    @IBAction func dateTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let date = dateFormatter.date(from: expirationTextField.text!)!
        datePickerView.date = date
        datePickerView.addTarget(self, action: #selector(ShoppingAddItemViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        expirationTextField.text = dateFormatter.string(from: sender.date)
        expirationDate = sender.date
    }

    @IBAction func saveAction(_ sender: Any) {
        let name = itemNameTextField.text!
        let cost = costTextField.text!
        let unit = unitTextField.text!
        let quantity = quantityTextField.text!
        let group = groupTextField.text!
        
        if (name != "") {
            
            let newDetails = ShoppingItem(
                listID: -1,
                itemID: id,
                itemName: name,
                itemCost: Double(0),
                unit: Constants.UnitBlank,
                quantity: Double(0),
                group: Constants.PantryOther,
                purchased: purchasedState,
                expirationDate: expirationDate,
                repurchase: false
            )
            
            if (group != "") {
                newDetails.group = group
            }
            
            if (unit != "") {
                newDetails.unit = unit
            }
            
            if (cost != "") {
                newDetails.itemCost = Double(cost)!
            }
            
            if (quantity != "") {
                newDetails.quantity = Double(quantity)!
            }
        
        
            updateShoppingItem(newDetails)
            print("Saving edits to database!")
        
            // initialize new view controller and cast it as your view controller
            let stack = self.navigationController?.viewControllers
            if ((stack?.count)! > 1) {
                observer.redrawTable()
            }
        
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
