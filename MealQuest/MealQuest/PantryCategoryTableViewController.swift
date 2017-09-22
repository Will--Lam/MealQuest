//
//  PantryCategoryTableViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryCategoryTableViewController: UITableViewController {

    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet var pantryCategoryTable: UITableView!
    
    var categorySelected = ""
    var allExpirations: [PantryExpiration] = []
    
    func redrawTable( ) {
        pantryCategoryTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redrawTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Constants.pantryGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PantryCategoryTableViewCell", for: indexPath) as! PantryCategoryTableViewCell

        let category = Constants.pantryGroups[indexPath.item]
        cell.categoryName.text = category
        cell.categoryIcon.image = UIImage(named: Constants.pantryIconMap[category]!)
        if (category == Constants.PantryAll) {
            cell.categoryStaleFactor.text = ""
            cell.categoryName.contentVerticalAlignment = .center
        } else {
            cell.categoryStaleFactor.text = "Days until expiring: " + String(getGroupExpiration(groupName: category))
        }
        return cell
    }

//** Look at allowing users to rearrange order of items
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! PantryCategoryTableViewCell
        
        categorySelected = currentCell.categoryName.text!
        
        performSegue(withIdentifier: "viewCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        if (segue.identifier == "viewCategory") {
            // initialize new view controller and cast it as your view controller
            let categoryVC = segue.destination as! PantryGroupTableViewController
            
            categoryVC.group = categorySelected
        } else if (segue.identifier == "addItem") {
            // initialize new view controller and cast it as your view controller
            let addVC = segue.destination as! PantryAddItemViewController
            addVC.itemGroupSuggestion = Constants.PantryAll
        }
    }

}
