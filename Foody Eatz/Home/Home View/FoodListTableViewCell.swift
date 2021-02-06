//
//  FoodListTableViewCell.swift
//  Foody Eatz
//
//  Created by developer on 06/02/21.
//  Copyright © 2021 Ashwini. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var foodDetailStackView: UIStackView!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var foodRateLabel: UILabel!
    @IBOutlet var addCartBtn: UIButton!
    @IBOutlet var foodView: UIView!
    @IBOutlet var shopName: UILabel!
    @IBOutlet var offerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
