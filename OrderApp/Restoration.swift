//
//  Restoration.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 29.12.21.
//

import Foundation


extension NSUserActivity {
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        
        set {
            if let newValue = newValue,
               let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else  {
                userInfo?["order"] = nil
            }
        }
    }
}

