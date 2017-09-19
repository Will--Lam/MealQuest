//
//  HistoryItemTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class HistoryItemTableViewController: UITableViewController {

    @IBOutlet var historyItemTable: UITableView!
    
    var observer: Observer!
    
    var shoppingItemList = [ShoppingItem]()
    var detailsPassed = [String:Any]()
    var cellID = Int64()
    
    func initializeTable( ) {
        self.historyItemTable.dataSource = self
        self.historyItemTable.delegate = self
        
        let cellNib = UINib(nibName: "ShoppingItemCell", bundle: nil)
        self.historyItemTable.register(cellNib, forCellReuseIdentifier: "ShoppingItemCell")
        
        shoppingItemList = getAllShoppingItems()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Historic Items"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        initializeTable()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItemList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryItemCell", for: indexPath) as! HistoryItemCell
        
        cell.id = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].id
        cell.quantity = "\(shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].quantity)"
        cell.unit = "\(shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].unit)"
        cell.name = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].name
        cell.cost = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].itemCost
        cell.group = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].group
        cell.purchased = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].purchased
        cell.expiration = shoppingItemList[shoppingItemList.index(shoppingItemList.startIndex, offsetBy: indexPath.item)].expirationDate
        
        cell.shoppingGroupImage.image = UIImage(named: cell.group)
        
        cell.itemNameLabel.text = cell.name + " (" + cell.quantity + " " + cell.unit + ")"
        cell.itemCostLabel.text = cell.cost.dollarString

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! HistoryItemCell
        
        let detailsPassed = ShoppingItem(
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
        
        // initialize new view controller and cast it as your view controller
        let stack = self.navigationController?.viewControllers
        if ((stack?.count)! > 1) {
            // Your new view controller should have property that will store passed value
            observer.populateFields(detailsPassed)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
