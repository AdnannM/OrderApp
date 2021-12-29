//
//  Restoration.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 29.12.21.
//

import Foundation



enum StateRestorantionController {
    
    init?(userActiviry: NSUserActivity) {
        guard let identifier = userActiviry.controllerIdentifier else {
            return nil
        }
        
        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActiviry.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActiviry.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
    
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
}

extension NSUserActivity {
    
    var controllerIdentifier: StateRestorantionController.Identifier? {
        get {
            if let controllerIdentifierString = userInfo?["controllerIdentifier"] as? String {
                return StateRestorantionController.Identifier(rawValue: controllerIdentifierString)!
            } else {
                return nil
            }
        }
        
        set {
            userInfo?["controllerIdentifier"] = newValue?.rawValue
        }
    }
    
    
    var menuCategory: String? {
        get {
            return userInfo?["menuCategory"] as? String
        }
        set {
            userInfo?["menuCategory"] = newValue
        }
    }
    
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?["menuItem"] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
         }
        
        set {
            if let newValue = newValue,
               let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["menuItem" : jsonData])
            } else {
                userInfo?["menuItem"] = nil
            }
        }
    }
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(Order.self,
               from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try?
               JSONEncoder().encode(newValue) {
            addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}


