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
    let unitPickerView = UIPickerView()
    
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
        
        unitPickerView.delegate = self
        unitPickerView.tag = 2
        unitTextField.inputView = unitPickerView
        
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
            return Constants.pantryGroups[row][0]
        } else if (pickerView.tag == 2) {
            return Constants.units[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            groupTextField.text = Constants.pantryGroups[row][0]
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

    @IBAction func saveAction(_ sender: Any) {
        let newDetails = ShoppingItem(
            listID: -1,
            itemID: id,
            itemName: itemNameTextField.text!,
            itemCost: Double(costTextField.text!)!,
            unit: unitTextField.text!,
            quantity: Double(quantityTextField.text!)!,
            group: groupTextField.text!,
            purchased: purchasedState,
            expirationDate: expirationDate,
            repurchase: false
        )
        
        updateShoppingItem(newDetails)
        print("Saving edits to database!")
        
        // initialize new view controller and cast it as your view controller
        let stack = self.navigationController?.viewControllers
        if ((stack?.count)! > 1) {
            observer.redrawTable()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
