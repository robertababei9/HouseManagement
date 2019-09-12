//
//  ProfileCollectionViewCell.swift
//  HouseManagement
//
//  Created by Robert Ababei on 30/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CustomizedUI.customizeContainerView(theView: containerView)
        CustomizedUI.addGradientToView(theView: containerView, gradientType: .sweetMorning)
    }

}
