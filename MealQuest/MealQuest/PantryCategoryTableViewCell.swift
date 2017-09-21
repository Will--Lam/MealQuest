//
//  PantryCategoryTableViewCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-09-21.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class PantryCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
