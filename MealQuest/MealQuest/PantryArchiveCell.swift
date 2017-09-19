//
//  PantryArchiveCell.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryArchiveCell: UITableViewCell {
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var itemExpire: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    var observer: PantryHistoryViewController!
    var searchObserver: SearchWPantryTableViewController!
    var search = false
    var pantryItem: PantryItem!
    
    @IBAction func toggleCheckBox(sender: UIButton) {
        if (search) {
//**        Toggle the search flag in pantry
            _ = SQLiteDB.instance.setSearchPantryItem(pantryId: pantryItem.id, current: pantryItem.search)
            
            searchObserver.refreshData()
        } else {
            _ = SQLiteDB.instance.togglePantryItem(pantryId: pantryItem.id, current: pantryItem.toggle)
        
            observer.refreshData()
        }
        /*
        // delete the item from pantry
        // _ = SQLiteDB.instance.deletePantryItem(pantryId: self.archiveArray[indexPath.item].id!)
             
        let deadlineTime = DispatchTime.now() + .milliseconds(200)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.refreshData()
        }
        */
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
