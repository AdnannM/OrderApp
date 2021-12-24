//
//  Order.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import Foundation


struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
