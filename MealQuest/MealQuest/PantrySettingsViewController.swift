//
//  PantrySettingsViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantrySettingsViewController: UIViewController {

    @IBOutlet weak var category1: UILabel!
    @IBOutlet weak var category2: UILabel!
    @IBOutlet weak var category3: UILabel!
    @IBOutlet weak var category4: UILabel!
    @IBOutlet weak var category5: UILabel!
    @IBOutlet weak var category6: UILabel!
    @IBOutlet weak var category7: UILabel!
    @IBOutlet weak var category8: UILabel!
    @IBOutlet weak var category9: UILabel!
    @IBOutlet weak var category10: UILabel!
    @IBOutlet weak var category11: UILabel!
    @IBOutlet weak var category12: UILabel!
    @IBOutlet weak var category13: UILabel!
    @IBOutlet weak var category14: UILabel!
    @IBOutlet weak var category15: UILabel!
    
    @IBOutlet weak var categoryStale1: UITextField!
    @IBOutlet weak var categoryStale2: UITextField!
    @IBOutlet weak var categoryStale3: UITextField!
    @IBOutlet weak var categoryStale4: UITextField!
    @IBOutlet weak var categoryStale5: UITextField!
    @IBOutlet weak var categoryStale6: UITextField!
    @IBOutlet weak var categoryStale7: UITextField!
    @IBOutlet weak var categoryStale8: UITextField!
    @IBOutlet weak var categoryStale9: UITextField!
    @IBOutlet weak var categoryStale10: UITextField!
    @IBOutlet weak var categoryStale11: UITextField!
    @IBOutlet weak var categoryStale12: UITextField!
    @IBOutlet weak var categoryStale13: UITextField!
    @IBOutlet weak var categoryStale14: UITextField!
    @IBOutlet weak var categoryStale15: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let logo = UIImage(named: "logoWhite.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let categoryLabels = [category1, category2, category3, category4, category5, category6, category7, category8, category9, category10, category11, category12, category13, category14, category15]
        
        // Set up all the labels
        for i in 1 ... (Constants.pantryGroups.count - 1) {
            categoryLabels[i - 1]?.text = Constants.pantryGroups[i]
        }
        
        // Set up the current stale values into the stale val
    }

    @IBAction func saveAction(_ sender: Any) {
        // let categoryStaleVals = [categoryStale1, categoryStale2, categoryStale3, categoryStale4, categoryStale5, categoryStale6, categoryStale7, categoryStale8, categoryStale9, categoryStale10, categoryStale11, categoryStale12, categoryStale13, categoryStale14, categoryStale15]
    }
    
}
