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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let categoryLabels = [category1, category2, category3, category4, category5, category6, category7, category8, category9, category10, category11, category12, category13, category14, category15]
        
        // Set up all the labels
        for i in 1 ... (Constants.pantryGroups.count - 1) {
            categoryLabels[i - 1]?.text = Constants.pantryGroups[i]
        }
        
        let categoryStale = [categoryStale1, categoryStale2, categoryStale3, categoryStale4, categoryStale5, categoryStale6, categoryStale7, categoryStale8, categoryStale9, categoryStale10, categoryStale11, categoryStale12, categoryStale13, categoryStale14, categoryStale15]
        // Set up the current stale values into the stale val
        for i in 1 ... (Constants.pantryGroups.count - 1) {
            categoryStale[i - 1]?.text = String(getGroupExpiration(groupName: (categoryLabels[i - 1]?.text!)!))
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        if ((categoryStale1.text == "") ||
            (categoryStale2.text == "") ||
            (categoryStale3.text == "") ||
            (categoryStale4.text == "") ||
            (categoryStale5.text == "") ||
            (categoryStale6.text == "") ||
            (categoryStale7.text == "") ||
            (categoryStale8.text == "") ||
            (categoryStale9.text == "") ||
            (categoryStale10.text == "") ||
            (categoryStale11.text == "") ||
            (categoryStale12.text == "") ||
            (categoryStale13.text == "") ||
            (categoryStale14.text == "") ||
            (categoryStale15.text == "")) {
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Confirm to add selected items to your pantry?", message: "", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let categoryStaleDictionary : [String: Int] = [
                category1.text!: Int(categoryStale1.text!)!,
                category2.text!: Int(categoryStale2.text!)!,
                category3.text!: Int(categoryStale3.text!)!,
                category4.text!: Int(categoryStale4.text!)!,
                category5.text!: Int(categoryStale5.text!)!,
                category6.text!: Int(categoryStale6.text!)!,
                category7.text!: Int(categoryStale7.text!)!,
                category8.text!: Int(categoryStale8.text!)!,
                category9.text!: Int(categoryStale9.text!)!,
                category10.text!: Int(categoryStale10.text!)!,
                category11.text!: Int(categoryStale11.text!)!,
                category12.text!: Int(categoryStale12.text!)!,
                category13.text!: Int(categoryStale13.text!)!,
                category14.text!: Int(categoryStale14.text!)!,
                category15.text!: Int(categoryStale15.text!)!]
            
                updateGroupExpiration(updateGroups: categoryStaleDictionary)
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
