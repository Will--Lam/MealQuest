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
            setSearchPantryItem(pantryId: pantryItem.id, searchValue: pantryItem.search)
            
            searchObserver.refreshData()
        } else {
            togglePantryItem(pantryId: pantryItem.id, toggleValue: pantryItem.toggle)
        
            observer.refreshData()
        }

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
