//
//  Work.swift
//  HouseManagement
//
//  Created by Robert Ababei on 27/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation

class Work {
    let date: String
    let name: String
    let type: String
    let autoId: String?
    
    init(date: String, name: String, type: String) {
        self.date = date
        self.name = name
        self.type = type
        autoId = nil
    }
    
    init(date: String, name: String, type: String, autoId: String?) {
        self.date = date
        self.name = name
        self.type = type
        self.autoId = autoId
    }
}
