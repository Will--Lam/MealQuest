//
//  ShoppingViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-05-25.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Observer {
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var subtotalValueLabel: UILabel!
    @IBOutlet weak var activeListTable: UITableView!
    
    var subtotalValue = Double()
    var shoppingItemList = [ShoppingItem]()
    var detailsPassed = ShoppingItem(id: -1)

    var cellID = Int64()
    var cost = Double()
    var purchased = Bool()
    
    func calculateSubtotal( ) {
        for item in shoppingItemList {
            if (item.purchased) {
                subtotalValue += item.itemCost
            }
        }
    }
    
    func updateDouble(_ cost: Double) {
        subtotalValue = cost + subtotalValue
        subtotalValueLabel.text = subtotalValue.dollarString
    }
    
    func redrawTable( ) {
        shoppingItemList = getActiveList()
        self.navigationItem.title = "Active (" + "\(shoppingItemList.count)" + ")"
        activeListTable.reloadData()
    }

    func populateFields(_: ShoppingItem) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.activeListTable.dataSource = self
        self.activeListTable.delegate = self
        
        let cellNib = UINib(nibName: "ShoppingItemCell", bundle: nil)
        self.activeListTable.register(cellNib, forCellReuseIdentifier: "ShoppingItemCell")
        
        shoppingItemList = getActiveList()
        
        calculateSubtotal()
        subtotalValueLabel.text = subtotalValue.dollarString
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Active (" + "\(shoppingItemList.count)" + ")"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shoppingItemList = getActiveList()
        self.navigationItem.title = "Active (" + "\(shoppingItemList.count)" + ")"
        activeListTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // print("drawing table now")
        return shoppingItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        
        cell.itemID = shoppingItemList[indexPath.item].id
        cell.quantity = "\(shoppingItemList[indexPath.item].quantity)"
        cell.unit = "\(shoppingItemList[indexPath.item].unit)"
        cell.name = shoppingItemList[indexPath.item].name
        cell.cost = shoppingItemList[indexPath.item].itemCost
        cell.group = shoppingItemList[indexPath.item].group
        cell.expiration = shoppingItemList[indexPath.item].expirationDate
        cell.purchased = shoppingItemList[indexPath.item].purchased
        
        if (cell.purchased) {
            cell.toggleButton.setImage(UIImage(named: "checkedBox.png"), for: .normal)
        } else {
            cell.toggleButton.setImage(UIImage(named: "uncheckedBox.png"), for: .normal)
        }

        cell.observer = self
        cell.shopping = true
        
        cell.shoppingGroupImage.image = UIImage(named: cell.group)
        
        cell.itemNameLabel.text = cell.name + " (" + cell.quantity + " " + cell.unit + ")"
        cell.itemCostLabel.text = cell.cost.dollarString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! ShoppingItemCell
        
        cellID = currentCell.itemID as Int64
        cost = currentCell.cost
        
        let purchased = currentCell.purchased
        
        if editingStyle == .delete {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Confirm to delete the current item from your shopping list?", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                
                deleteShoppingItem(self.cellID)
                print("Delete item from database!")
                
                // initialize new view controller and cast it as your view controller
                if (purchased) {
                    self.updateDouble(self.cost * -1)
                }
                self.redrawTable()
                
            }))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ShoppingItemCell
        
        cellID = currentCell.itemID as Int64
        cost = currentCell.cost
        purchased = currentCell.purchased
        
        detailsPassed = ShoppingItem(
            listID: -1,
            itemID: -1,
            itemName: currentCell.name,
            itemCost: Double(currentCell.cost),
            unit: currentCell.unit,
            quantity: Double(currentCell.quantity)!,
            group: currentCell.group,
            purchased: currentCell.purchased,
            expirationDate: currentCell.expiration,
            repurchase: false
        )
        
        performSegue(withIdentifier: "editItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "editItem") {
            // initialize new view controller and cast it as your view controller
            let editVC = segue.destination as! ShoppingEditItemViewController
            // Your new view controller should have property that will store passed value
            editVC.itemDetails = detailsPassed
            editVC.id = cellID
            editVC.cost = cost
            editVC.purchasedState = purchased
            editVC.observer = self
        }
        
        if (segue.identifier == "compareItem") {
            // initialize new view controller and cast it as your view controller
            let compareVC = segue.destination as! ShoppingCompareViewController
            // Your new view controller should have property that will store passed value
            compareVC.observer = self
        }

        
        if (segue.identifier == "addItem") {
            // initialize new view controller and cast it as your view controller
            let addVC = segue.destination as! ShoppingAddItemViewController
            // Your new view controller should have property that will store passed value
            addVC.observer = self
        }
        
        if (segue.identifier == "viewHistory") {
            // initialize new view controller and cast it as your view controller
            let historyVC = segue.destination as! ShoppingHistoryListViewController
            // Your new view controller should have property that will store passed value
            historyVC.observer = self
        }
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm to add selected items to your pantry?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            shoppingCheckout(self.subtotalValue)
            
            self.shoppingItemList = getActiveList()
            self.subtotalValue = 0.00
            self.subtotalValueLabel.text = self.subtotalValue.dollarString
            self.redrawTable()
            print("Add items to pantry!")
            
            // Need to tell pantry to redraw too
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}

