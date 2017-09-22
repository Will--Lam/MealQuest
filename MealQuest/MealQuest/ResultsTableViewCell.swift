//
//  RecipeTableViewCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-06.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    var id = Int64()
    var imageURL = String()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
