//
//  Array+RemoveWork.swift
//  HouseManagement
//
//  Created by Robert Ababei on 11/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation

extension Array {
    func removeAt(work: Work) -> [Work] {
        var selfArray = self as! [Work]
        var index = 0
        for myWork in selfArray {
            if myWork.name == work.name && myWork.date == work.date && myWork.type == work.type {
                selfArray.remove(at: index)
                break
            }
            index += 1
        }
        return selfArray
    }
}
