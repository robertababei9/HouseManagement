//
//  StatisticsPerTotal.swift
//  HouseManagement
//
//  Created by Robert Ababei on 12/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation

class StatisticsPerTotal {
    var userName: String
    var numberOfWorks: Int = 0
    
    init(userName: String, noWorks: Int) {
        self.userName = userName
        numberOfWorks = noWorks
    }
}
