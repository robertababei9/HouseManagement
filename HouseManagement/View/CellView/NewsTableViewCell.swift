//
//  NewsTableViewCell.swift
//  HouseManagement
//
//  Created by Robert Ababei on 28/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CustomizedUI.customizeTableViewCell(theCell: self, cellType: .newsfeed)
    }
    
}
