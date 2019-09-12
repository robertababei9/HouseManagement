//
//  FirebaseAPI.swift
//  HouseManagement
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseAPI {
    
    static var ref = Database.database().reference()
    
    static func fetchWorksForUser(withId userId: String, completion: @escaping (Work) -> Void){
        ref.child("usersWork").child(userId).observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
                if let date = dict["date"] as? String, let name = dict["name"] as? String, let type = dict["type"] as? String {
                    let work = Work(date: date, name: name, type: type)
                    DispatchQueue.main.async {
                        completion(work)
                    }
                }
            }
        }
    }
}
