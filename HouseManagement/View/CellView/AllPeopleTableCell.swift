//
//  AllPeopleTableCell.swift
//  HouseManagement
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit

class AllPeopleTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        CustomizedUI.customizeTableViewCell(theCell: self, cellType: .allPeople)
    }
    
}
