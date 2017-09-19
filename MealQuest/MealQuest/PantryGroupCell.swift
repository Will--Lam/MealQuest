//
//  PantryGroupCell.swift
//  MealQuest
//
//  Created by Mary Hu on 2017-06-17.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryGroupCell: UITableViewCell {
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemExpire: UILabel!
    @IBOutlet var icon: UIImageView!
    
    var currentItem = PantryItem(id: 1)
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
