//
//  ShoppingHistoryListViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-20.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingHistoryListViewController: UITableViewController {
    
    @IBOutlet var historyListsTable: UITableView!
    
    var historicLists = [ShoppingLists]()
    var listDetails = [ShoppingItem]()
    var subtotal = Double()
    var date = String()
    var listID = Int64()
    
    var observer: Observer!
    
    func redrawTable( ) {
        historyListsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Historic Lists"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        historicLists = getHistoricLists()

    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historicLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryListTableViewCell", for: indexPath) as! HistoryListTableViewCell
        
        cell.listID = historicLists[indexPath.item].listID
        cell.listSubtotal = historicLists[indexPath.item].listCost
        cell.listTotalLabel.text = cell.listSubtotal.dollarString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        cell.listDateLabel.text = dateFormatter.string(from: historicLists[indexPath.item].listDate)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! HistoryListTableViewCell
        
        listID = currentCell.listID as Int64
        
        if editingStyle == .delete {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Confirm to delete the current item from your shopping list?", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                
                deleteHistoricList(self.listID)
                print("Delete list from database!")
                
                // initialize new view controller and cast it as your view controller
                self.historicLists = getHistoricLists()
                self.redrawTable()
                
            }))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! HistoryListTableViewCell
        
        listID = currentCell.listID as Int64
        
        print("id is: " + "\(listID)")
        listDetails = getSelectedShoppingList(listID)
        
        subtotal = currentCell.listSubtotal
        date = currentCell.listDateLabel.text!
        
        performSegue(withIdentifier: "viewHistoricList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewHistoricList") {
            // initialize new view controller and cast it as your view controller
            let historyDetailsVC = segue.destination as! ShoppingHistoryDetailsViewController
            // your new view controller should have property that will store passed value
            historyDetailsVC.listDetails = listDetails
            historyDetailsVC.subtotal = subtotal
            historyDetailsVC.date = date
            historyDetailsVC.listID = listID
            historyDetailsVC.observer = observer
        }
    }
    
}
