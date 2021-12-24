//
//  OrderResponse.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import Foundation


struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
