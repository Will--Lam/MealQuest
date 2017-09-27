//
//  PantryHistoryViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-18.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addShoppingButton: UIBarButtonItem!
    
    @IBOutlet weak var archiveTable: UITableView!
    
    var archiveArray = [PantryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: Constants.mqWhiteColour
        ]
        
        self.navigationItem.title = "Historic Items"
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        // Do any additional setup after loading the view.
        
        // set data source for tables
        archiveTable.dataSource = self
        archiveTable.delegate = self
    
        // register cell nib
        let cellNib = UINib(nibName: "PantryArchiveCell", bundle: nil)
        archiveTable.register(cellNib, forCellReuseIdentifier: "PantryArchiveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload new data
        refreshData()
    }
    
    func refreshData() {
        archiveArray = getGroupPantryItemArchived()
        archiveTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryArchiveCell", for: indexPath) as! PantryArchiveCell
        
        cell.itemName.text = archiveArray[indexPath.item].name
        if (archiveArray[indexPath.item].toggle == 0) {
            cell.checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
        }
        
        let date = self.archiveArray[indexPath.item].archive
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        cell.itemExpire.text = "Archived on " + dateFormatter.string(from: date)
        
        cell.groupImage.image = UIImage(named: Constants.pantryIconMap[archiveArray[indexPath.item].group]!)
        
        cell.observer = self
        cell.pantryItem = archiveArray[indexPath.item]

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // add all toggled items to shopping list
    @IBAction func addShoppingAction(_ sender: Any) {
        var response = -1
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Confirm to add the selected items to your current shopping list?", message: "", preferredStyle: .alert)
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            // get all toggled items
            let items = getToggledPantryItems()
            
            // add toggled items to shopping list
//**        Need to get a response from addPantryItems to signal success
            addPantryItemsToShoppingList(items)
            response = 1
            
            self.refreshData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        if (response != -1) {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Selected pantry items have been added to the active shopping list.", message: "", preferredStyle: .alert)
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }

    }

}
