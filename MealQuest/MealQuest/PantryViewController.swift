//
//  PantryViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-05-25.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryViewController: UIViewController {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var veggiesButton: UIButton!
    @IBOutlet weak var proteinButton: UIButton!
    @IBOutlet weak var bakeryButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    var viewGroup: String!
    var groupIcon: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToAllAction(_ sender: Any) {
        viewGroup = Constants.PantryAll
        groupIcon = "Pantry_Group_All"
    }
    
    @IBAction func goToDiaryAction(_ sender: Any) {
        viewGroup = Constants.PantryDairy
        groupIcon = "Pantry_Group_Dairy"
        
    }
    
    @IBAction func goToBakeryAction(_ sender: Any) {
        viewGroup = Constants.PantryBakery
        groupIcon = "Pantry_Group_Bakery"
    }
    
    @IBAction func goToProteinAction(_ sender: Any) {
        viewGroup = Constants.PantryProteins
        groupIcon = "Pantry_Group_Proteins"
    }
    
    @IBAction func goToOtherAction(_ sender: Any) {
        viewGroup = Constants.PantryOther
        groupIcon = "Pantry_Group_Other"
    }
    
    @IBAction func goToVeggiesAction(_ sender: Any) {
        viewGroup = Constants.PantryVeggies
        groupIcon = "Pantry_Group_Veggies"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewHistory") {
            
        } else if (segue.identifier == "addItem") {
            let addVC = segue.destination as! PantryAddItemViewController
            addVC.itemGroupSuggestion = "Other Grocery"
        } else {
            let groupVC = segue.destination as! PantryGroupTableViewController
            groupVC.group = viewGroup
            groupVC.groupIcon = groupIcon
        }
        
    }

}

