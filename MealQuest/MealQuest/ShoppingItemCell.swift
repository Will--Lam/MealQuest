//
//  ShoppingItemCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {

    @IBOutlet weak var itemCostLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var shoppingGroupImage: UIImageView!
    
    var observer: Observer!
    
    var shopping = Bool()
    
    var cost = Double()
    var name = String()
    var unit = String()
    var quantity = String()
    var group = String()
    var purchased = Bool()
    var repurchased = false
    var expiration = Date()
    var itemID = Int64()
    var listID = Int64()
    
    @IBAction func toggleAction(_ sender: UIButton) {
        if (shopping) {
            purchased = !purchased
            changePurchasedState(ItemID: itemID, purchasedState: purchased)
            if (purchased) {
                observer.updateDouble(Double(cost))
                toggleButton.setImage(UIImage(named: "checkedBox.png"), for: .normal)
            } else {
                observer.updateDouble(Double(cost) * -1)
                toggleButton.setImage(UIImage(named: "uncheckedBox.png"), for: .normal)
            }
        } else {
            repurchased = !repurchased
            changeRepurchaseState(ListID: listID, ItemID: itemID, repurchaseState: repurchased)
            if (repurchased) {
                toggleButton.setImage(UIImage(named: "checkedBox.png"), for: .normal)
            } else {
                toggleButton.setImage(UIImage(named: "uncheckedBox.png"), for: .normal)
            }
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
