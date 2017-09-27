//
//  PantryAddItemViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-18.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryAddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemQuantity: UITextField!
    @IBOutlet weak var itemUnit: UITextField!
    @IBOutlet weak var itemGroup: UITextField!
    var itemGroupSuggestion = String()
    @IBOutlet weak var itemPurchaseDate: UITextField!
    @IBOutlet weak var itemExpirationDate: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let groupPickerView = UIPickerView()
    let unitPickerView = UIPickerView()
    
    var purchaseDate    = Date()
    var expirationDate  = Date()
    var archiveDate     = Date()
    
    var viewItem = PantryItem(id: 1)
    var viewMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
        
        groupPickerView.delegate = self
        groupPickerView.tag = 1
        itemGroup.inputView = groupPickerView
        
        unitPickerView.delegate = self
        unitPickerView.tag = 2
        itemUnit.inputView = unitPickerView
        
        if (viewMode == false) {
            itemQuantity.isUserInteractionEnabled = true
            itemQuantity.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            itemUnit.text = Constants.units[0]
            
            itemGroup.text = itemGroupSuggestion
            if (itemGroupSuggestion == "All") {
                itemGroup.text = "Other Grocery"
                itemGroupSuggestion = "Other Grocery"
            }
            
            // pre-fill in the category based on where the add button was pressed from
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            itemPurchaseDate.text = dateFormatter.string(from: purchaseDate)
            itemExpirationDate.text = dateFormatter.string(from: expirationDate)
        } else {
            // set values from viewItem
            itemName.text = viewItem.name
            itemQuantity.text = String(viewItem.quantity)
            // itemQuantity.isUserInteractionEnabled = false
            // itemQuantity.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            itemGroup.text = viewItem.group
            itemUnit.text = viewItem.unit
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            itemPurchaseDate.text = dateFormatter.string(from: viewItem.purchase)
            purchaseDate = viewItem.purchase
            itemExpirationDate.text = dateFormatter.string(from: viewItem.expiration)
            expirationDate = viewItem.expiration
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return Constants.pantryGroups.count
        } else if (pickerView.tag == 2) {
            return Constants.units.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return Constants.pantryGroups[row]
        } else if (pickerView.tag == 2) {
            return Constants.units[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            itemGroup.text = Constants.pantryGroups[row]
        } else if (pickerView.tag == 2) {
            itemUnit.text = Constants.units[row]
        }
    }
    
    func purchaseDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        itemPurchaseDate.text = dateFormatter.string(from: sender.date)
        purchaseDate = sender.date
    }
    
    @IBAction func purchaseTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(PantryAddItemViewController.purchaseDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func expirationDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        itemExpirationDate.text = dateFormatter.string(from: sender.date)
        expirationDate = sender.date
    }
    
    @IBAction func expirationTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(PantryAddItemViewController.expirationDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func failSaveAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Failed to save pantry item.", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        // validate input
        var valid = true
        
        if ((itemName.text?.isEmpty)!  || (itemQuantity.text?.isEmpty)! ) {
            valid = false
        }
        
        // alert if input is wrong
        if (valid == false) {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Please ensure required fields are filled!", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        } else {
            // save content to db
            let purchaseString = SQLDateFormatter.string(from: purchaseDate)
            let expireString = SQLDateFormatter.string(from: expirationDate)
            
            let itemNameString = itemName.text
            let itemCaloriesVal = ""
            let itemQuantityVal = itemQuantity.text
            
            var itemCaloriesInput = 0
            if (!(itemCaloriesVal.isEmpty)) {
                itemCaloriesInput = Int(itemCaloriesVal)!
            }
            
            // TODO: remove debug output
            print(itemNameString!)
            print(itemCaloriesVal)
            print(itemQuantityVal!)
            print(itemCaloriesInput)
            print(itemUnit)
            print(itemGroup)
            print(purchaseString)
            print(expireString)
            
            var res: Int64?
            res = 1
            var message = "Pantry Item successfully added!"
                
            if (viewMode == false) {
                let newPantryItem = PantryItem(
                    id:             -1,
                    name:           itemNameString!,
                    group:          itemGroup.text!,
                    quantity:       Double(itemQuantityVal!)!,
                    unit:           itemUnit.text!,
                    calories:       itemCaloriesInput,
                    isArchive:      0,
                    expiration:     expirationDate,
                    purchase:       purchaseDate,
                    archive:        archiveDate,
                    toggle:         0,
                    search:         0)
                createPantryItem(itemInfo: newPantryItem)
            } else {
                
                let newPantryItem = PantryItem(
                    id:             viewItem.id,
                    name:           itemNameString!,
                    group:          itemGroup.text!,
                    quantity:       Double(itemQuantityVal!)!,
                    unit:           itemUnit.text!,
                    calories:       itemCaloriesInput,
                    isArchive:      0,
                    expiration:     expirationDate,
                    purchase:       purchaseDate,
                    archive:        archiveDate,
                    toggle:         0,
                    search:         0)
                
                updatePantryItem(itemInfo: newPantryItem)
            }
                
            if (res == nil) {
                failSaveAlert()
            } else {
                // go back to previous group view
                _ = navigationController?.popViewController(animated: true)
                let groupView = self.view.window?.rootViewController
                    
                //1. Create the alert controller.
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Close", style: .default))
                // 4. Present the alert in new controller.
                groupView?.present(alert, animated: true, completion: nil)
                
            }
        }
    }

}
