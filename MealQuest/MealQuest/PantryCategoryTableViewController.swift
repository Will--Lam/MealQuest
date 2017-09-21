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
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet var pantryCategoryTable: UITableView!
    
    var categorySelected = ""
    
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
        return cell
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

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
        }
    }

}
