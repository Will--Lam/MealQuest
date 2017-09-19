//
//  RecipeViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-06.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var resultsPassed = [[String:Any]]()
    var detailsPassed = [String:Any]()
    var cellID = Int64()
    var favoriteTable = false
    
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var addRecipeButton: UIButton!
    
    func redrawTable( ) {
        resultsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        if (!favoriteTable) {
            addRecipeButton.isEnabled = false
            addRecipeButton.isHidden = true
        } else {
            addRecipeButton.isEnabled = true
            addRecipeButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!favoriteTable) {
            addRecipeButton.isEnabled = false
            addRecipeButton.isHidden = true
        } else {
            addRecipeButton.isEnabled = true
            addRecipeButton.isHidden = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsPassed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        
        let idVal = resultsPassed[indexPath.item]["id"] as! Int64
        let titleText = resultsPassed[indexPath.item]["title"] as? String
        let calorieVal = resultsPassed[indexPath.item]["calorie"] as? String
        // let calorieText = "\(calorieVal!)"
        
        let imageURL = resultsPassed[indexPath.item]["imageURL"] as? String
        var imageRendered = false
        cell.recipeImage.contentMode = .scaleAspectFit
        if let checkedUrl = URL(string: imageURL!) {
            getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                // print(response?.suggestedFilename ?? checkedUrl.lastPathComponent)
                DispatchQueue.main.async() { () -> Void in
                    cell.recipeImage.image = UIImage(data: data)
                    imageRendered = true
                }
            }
        }
        if (!imageRendered) {
            print("Attempting to set default photo now in search results")
            cell.recipeImage.image = UIImage(named: "defaultPhoto")
        }
        
        // Configure the cell...
        print("idVal is: " + "\(idVal)")
        cell.id = idVal
        cell.titleLabel.text = titleText
        cell.calorieLabel.text = calorieVal
        cell.imageURL = imageURL!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ResultsTableViewCell
        
        cellID = currentCell.id as Int64
        
        if (cellID != -1) {
            print("id is: " + "\(cellID)")
            detailsPassed = SQLiteDB.instance.getRecipeFieldFromDB(recipeID: cellID)
        } else {
            detailsPassed = [
                "title": currentCell.titleLabel.text!,
                "calorie": currentCell.calorieLabel.text!,
                "imageURL": currentCell.imageURL as String
            ]
        }

        performSegue(withIdentifier: "viewDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
    
        if (segue.identifier == "viewDetails") {
            // initialize new view controller and cast it as your view controller
            let recipeVC = segue.destination as! RecipeViewController
            // your new view controller should have property that will store passed value
            recipeVC.recipeDetails = detailsPassed
            recipeVC.id = cellID
            recipeVC.observer = self
            recipeVC.redrawFavorite = favoriteTable
        }
        
        if (segue.identifier == "addRecipe") {
            let addVC = segue.destination as! AddRecipeViewController
            addVC.resultsObserver = self
        }
    }

}
