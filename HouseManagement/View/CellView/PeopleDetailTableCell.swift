//
//  PeopleDetailsTableCell.swift
//  HouseManagement
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit

class PeopleDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        CustomizedUI.customizeTableViewCell(theCell: self, cellType: .detailPeople)
    }
}
