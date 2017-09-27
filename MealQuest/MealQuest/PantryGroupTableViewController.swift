//
//  PantryGroupTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-10.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryGroupTableViewController: UITableViewController {

    @IBOutlet var itemTable: UITableView!
    @IBOutlet weak var newItemButton: UIBarButtonItem!
    
    var group = "Group View"
    
    var numSections = ["Expiring", "All Other"]
    var expiringArray = [PantryItem]()
    var otherArray = [PantryItem]()
    var allItemsArray = [[PantryItem]]()
    
    var viewItem = PantryItem(id: 1)
    
    func redrawTable( ) {
        expiringArray = getGroupPantryItemStale(pantryGroup: group)
        otherArray = getGroupPantryItemFresh(pantryGroup: group)
        allItemsArray = [expiringArray, otherArray]
        itemTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.itemTable.dataSource = self
        self.itemTable.delegate = self
        
        let cellNib = UINib(nibName: "PantryGroupCell", bundle: nil)
        self.itemTable.register(cellNib, forCellReuseIdentifier: "PantryGroupCell")
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = group
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        
        otherArray = getGroupPantryItemFresh(pantryGroup: group)
        expiringArray = getGroupPantryItemStale(pantryGroup: group)
        
        allItemsArray = [expiringArray, otherArray]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redrawTable()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // sprint("drawing table now")
        return allItemsArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < numSections.count {
            return numSections[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryGroupCell", for: indexPath) as! PantryGroupCell
        
        let name = allItemsArray[indexPath.section][indexPath.row].name
        let quantity = allItemsArray[indexPath.section][indexPath.row].quantity.roundTo(places: 2)
        let unit = allItemsArray[indexPath.section][indexPath.row].unit
        cell.itemName.text = name + " (" + "\(quantity)" + " " + unit + ")"
        
        let date = allItemsArray[indexPath.section][indexPath.row].expiration
        let dateText = getRelativeDate(date: date)
        let last2 = dateText.substring(from:dateText.index(dateText.endIndex, offsetBy: -2))
        if (last2 == "d.") {
            cell.itemExpire.textColor = UIColor.red
        } else {
            cell.itemExpire.textColor = UIColor.gray
        }
        cell.itemExpire.text = dateText
        
        cell.icon.image = UIImage(named: Constants.pantryIconMap[allItemsArray[indexPath.section][indexPath.row].group]!)
        
        cell.currentItem = allItemsArray[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let currentCell = allItemsArray[indexPath.section][indexPath.row]
        
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Confirm to delete the current item from your pantry?", message: "", preferredStyle: .alert)
        
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
                archivePantryItem(pantryId: currentCell.id)
                print("Delete item from database!")
            
                // initialize new view controller and cast it as your view controller
                self.redrawTable()
            
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func badInputAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Please enter a valid quantity to consume.", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row) in section #\(indexPath.section)!")
        
        // Get Cell Label
        viewItem = allItemsArray[indexPath.section][indexPath.row]
        
        performSegue(withIdentifier: "viewItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewItem") {
            // initialize new view controller and cast it as your view controller
            let viewVC = segue.destination as! PantryAddItemViewController
            // your new view controller should have property that will store passed value
            viewVC.viewItem = viewItem
            viewVC.viewMode = true
        } else
        
        if (segue.identifier == "addItem") {
            let addVC = segue.destination as! PantryAddItemViewController
            addVC.itemGroupSuggestion = group
        }
        
    }
}
