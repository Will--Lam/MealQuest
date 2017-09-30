//
//  RecipeCategoryTableViewCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-22.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class RecipeCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeCategoryName: UILabel!
    @IBOutlet weak var recipeCategoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
