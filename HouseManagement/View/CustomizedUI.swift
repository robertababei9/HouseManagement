//
//  CustomizedUI.swift
//  HouseManagement
//
//  Created by Robert Ababei on 27/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation
import UIKit

enum PictureType {
    case profile
}

enum ButtonType {
    case shine
    case dark
    case delete
}

enum GradientType {
    case redOrange
    case pizelex
    case sweetMorning
}

enum CellType {
    case newsfeed
    case allPeople
    case detailPeople
}

class CustomizedUI {
    
     static func customizeTextField(theTextField: UITextField) {
        theTextField.borderStyle = .none
        theTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: theTextField.bounds.height + 5, width: theTextField.bounds.width, height: 2))
        bottomLine.backgroundColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1)
        
        theTextField.addSubview(bottomLine)
    }
    
    static func customizeButton(theButton: UIButton, type: ButtonType) {
        theButton.layer.cornerRadius = 15
        theButton.tintColor = .white
        
        switch type {
        case .shine:
            theButton.backgroundColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1)
        case .dark:
            theButton.backgroundColor = UIColor(displayP3Red: 106 / 255, green: 117 / 255, blue: 131 / 255, alpha: 1)
        case .delete:
            theButton.backgroundColor = .red
            theButton.alpha = 0.5
        }
    }
    
    static func customizeNavigationBar(theBar: UINavigationBar) {
        theBar.barTintColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1)
        theBar.layer.cornerRadius = 7
        theBar.clipsToBounds = true
    }
    
    static func customizeTableViewCell(theCell: UITableViewCell, cellType: CellType) {
        theCell.backgroundColor = UIColor(displayP3Red: 106 / 255, green: 117 / 255, blue: 131 / 255, alpha: 1)
        switch cellType {
        case .newsfeed:
            let newsCell = theCell as! NewsTableViewCell
            
            newsCell.profilePicture.layer.cornerRadius = newsCell.profilePicture.frame.height / 2
            newsCell.profilePicture.layer.borderWidth = 3
            newsCell.profilePicture.layer.borderColor = UIColor.white.cgColor
            //---Text colors
            newsCell.nameLabel.textColor = .white
            newsCell.dateLabel.textColor = .white
            newsCell.typeLabel.textColor = UIColor(displayP3Red: 161 / 255, green: 172 / 255, blue: 185 / 255, alpha: 1)
        case .allPeople:
            let allPeopleCell = theCell as! AllPeopleTableCell
            allPeopleCell.nameLabel.textColor = .white
        default:
            let detailPeopleCell = theCell as! PeopleDetailTableCell
            detailPeopleCell.dateLabel.textColor = .white
            detailPeopleCell.typeLabel.textColor = .white
            
        }
    }
    
    static func customizePickerView(thePicker: UIPickerView) {
        thePicker.layer.cornerRadius = 10
        thePicker.clipsToBounds = true
        thePicker.layer.borderWidth = 3
        thePicker.layer.borderColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1).cgColor
        thePicker.backgroundColor = UIColor(displayP3Red: 91 / 255, green: 101 / 255, blue: 112 / 255, alpha: 1)
    }
    
    static func customizeDatePickerView(thePicker: UIDatePicker) {
        thePicker.layer.cornerRadius = 10
        thePicker.clipsToBounds = true
        thePicker.layer.borderWidth = 3
        thePicker.layer.borderColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1).cgColor
        thePicker.backgroundColor = UIColor(displayP3Red: 91 / 255, green: 101 / 255, blue: 112 / 255, alpha: 1)
    }
    
    static func customizeImageView(theImage: UIImageView, type: PictureType) {
        switch type {
        case .profile:
            theImage.layer.cornerRadius = theImage.frame.height / 2
            theImage.layer.borderWidth = 3
            theImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    static func addGradientToView(theView: UIView, gradientType: GradientType) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = theView.bounds
        gradientLayer.cornerRadius = theView.layer.cornerRadius
        var color1: UIColor
        var color2: UIColor
        switch gradientType {
        case .redOrange:
            color1 = UIColor(displayP3Red: 255 / 255, green: 161 / 255, blue: 135 / 255, alpha: 1)
            color2 = UIColor(displayP3Red: 180 / 255, green: 56 / 255, blue: 56 / 255, alpha: 1)
        case .pizelex:
            color1 = UIColor(displayP3Red: 17 / 255, green: 67 / 255, blue: 87 / 255, alpha: 1)
            color2 = UIColor(displayP3Red: 242 / 255, green: 148 / 255, blue: 145 / 255, alpha: 1)
        case .sweetMorning:
            color1 = UIColor(displayP3Red: 255 / 255, green: 95 / 255, blue: 109 / 255, alpha: 1)
            color2 = UIColor(displayP3Red: 255 / 255, green: 195 / 255, blue: 113 / 255, alpha: 1)
        }
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        theView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func customizeContainerView(theView: UIView) {
        theView.clipsToBounds = true
        theView.layer.cornerRadius = 15
//        theView.backgroundColor = UIColor(displayP3Red: 238 / 255, green: 119 / 255, blue: 108 / 255, alpha: 1)
    }
}
