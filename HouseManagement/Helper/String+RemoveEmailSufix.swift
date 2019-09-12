//
//  String+RemoveEmailSufix.swift
//  HouseManagement
//
//  Created by Robert Ababei on 12/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation

extension String {
    func removeEmailSuffix() -> String {
        var resultString = self
        resultString.removeSubrange(resultString.firstIndex(of: "@")! ..< resultString.endIndex)
        return resultString
    }
}
