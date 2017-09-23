//
//  ShoppingAddItemViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-20.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingAddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, Observer {
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    var purchasedState = false
    @IBOutlet weak var expirationTextField: UITextField!
    var expirationDate = Date()
    var observer: Observer!
    
    let groupPickerView = UIPickerView()
    let unitPickerView = UIPickerView()
    
    @IBOutlet weak var selectFromHistoryButton: UIButton!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    func populateFields( _ details: ShoppingItem) {
        itemNameTextField.text = details.name
        quantityTextField.text = "\(details.quantity)"
        unitTextField.text = details.unit
        groupTextField.text = details.group
        costTextField.text = String(format: "%.2f", details.itemCost)
    }
    
    func redrawTable() { }
    func updateDouble(_: Double) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
        
        groupPickerView.delegate = self
        groupPickerView.tag = 1
        groupTextField.inputView = groupPickerView
        groupTextField.text = Constants.pantryGroups[0]
        
        unitPickerView.delegate = self
        unitPickerView.tag = 2
        unitTextField.inputView = unitPickerView
        unitTextField.text = Constants.units[0]

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        expirationTextField.text = dateFormatter.string(from: expirationDate)
        
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
            groupTextField.text = Constants.pantryGroups[row]
        } else if (pickerView.tag == 2) {
            unitTextField.text = Constants.units[row]
        }
    }
    
    @IBAction func dateTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ShoppingAddItemViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        expirationTextField.text = dateFormatter.string(from: sender.date)
        expirationDate = sender.date
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        
        let name = itemNameTextField.text!
        let cost = costTextField.text!
        let quantity = quantityTextField.text!
        let unit = unitTextField.text!
        let group = groupTextField.text!
        if (name != "") {

            let newDetails = ShoppingItem(
                listID: -1,
                itemID: -1,
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
            
            saveNewShoppingItem(newDetails)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewOldItems") {
            // initialize new view controller and cast it as your view controller
            let historicItemsVC = segue.destination as! HistoryItemTableViewController
            // Your new view controller should have property that will store passed value
            historicItemsVC.observer = self
        }
        
    }
    
}
