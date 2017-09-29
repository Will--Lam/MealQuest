//
//  ShoppingHistoryDetailsViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-20.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingHistoryDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Observer {
    
    @IBOutlet weak var historicListTable: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var listDetails = [ShoppingItem]()
    var subtotal = Double()
    var date = String()
    var listID = Int64()
    var itemID = Int64()
    
    var observer: Observer!
    
    func updateDouble(_: Double) { }
    func redrawTable() { }
    func populateFields(_: ShoppingItem) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = date
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        subtotalLabel.text = subtotal.dollarString
        
        self.historicListTable.dataSource = self
        self.historicListTable.delegate = self
        
        let cellNib = UINib(nibName: "ShoppingItemCell", bundle: nil)
        self.historicListTable.register(cellNib, forCellReuseIdentifier: "ShoppingItemCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // print("drawing table now")
        return listDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        
        cell.itemID = listDetails[indexPath.item].id
        cell.listID = listID
        cell.quantity = "\(listDetails[indexPath.item].quantity)"
        cell.unit = "\(listDetails[indexPath.item].unit)"
        cell.name = listDetails[indexPath.item].name
        cell.cost = listDetails[indexPath.item].itemCost
        cell.group = listDetails[indexPath.item].group
        cell.purchased = listDetails[indexPath.item].purchased
        cell.expiration = listDetails[indexPath.item].expirationDate
        cell.repurchased = listDetails[indexPath.item].repurchase
        
        if (cell.repurchased) {
            cell.toggleButton.setImage(UIImage(named: "checkedBox.png"), for: .normal)
        } else {
            cell.toggleButton.setImage(UIImage(named: "uncheckedBox.png"), for: .normal)
        }
        
        cell.shoppingGroupImage.image = UIImage(named: Constants.pantryIconMap[cell.group]!)
        
        cell.observer = self
        cell.shopping = false
        
        cell.itemNameLabel.text = cell.name + " (" + cell.quantity + " " + cell.unit + ")"
        cell.itemCostLabel.text = cell.cost.dollarString
        
        return cell
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        var response = -1
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm to add the selected items to your current shopping list?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
//**        Need to add a response from addSelectedItems to signal success
            addSelectedItemsToShoppingList(self.listID)
            self.historicListTable.reloadData()
            
            response = 1
            print("Adding items to active list!")
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        if (response != -1) {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Selected items have been added to the shopping list.", message: "", preferredStyle: .alert)
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }

}
