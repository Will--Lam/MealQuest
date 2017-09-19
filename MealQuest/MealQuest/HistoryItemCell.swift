//
//  HistoryItemCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class HistoryItemCell: UITableViewCell {

    @IBOutlet weak var itemCostLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var shoppingGroupImage: UIImageView!
    
    var cost = Double()
    var name = String()
    var unit = String()
    var quantity = String()
    var group = String()
    var purchased = Bool()
    var expiration = Date()
    var id = Int64()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
