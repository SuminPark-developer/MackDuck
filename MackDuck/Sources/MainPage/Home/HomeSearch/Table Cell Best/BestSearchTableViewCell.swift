//
//  BestSearchTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2021/11/30.
//

import UIKit

class BestSearchTableViewCell: UITableViewCell {

    static let identifier = "BestSearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BestSearchTableViewCell", bundle: nil)
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
