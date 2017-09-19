//
//  HistoryListTableViewCell.swift
//  MealQuest
//
//  Created by Will Lam on 2017-07-05.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class HistoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var listDateLabel: UILabel!
    @IBOutlet weak var listTotalLabel: UILabel!
    var listID = Int64()
    var listSubtotal = Double()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
