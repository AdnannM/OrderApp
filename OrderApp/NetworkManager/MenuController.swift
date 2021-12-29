//
//  MenuController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 25.12.21.
//

import Foundation
import UIKit

class MenuController {
    static let shared = MenuController()
    
    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
            userActivity.order = order
        }
    }
    
    static let orderUpdateNotification = Notification.Name("MenuController.OrderUpdate")
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    let baseURL = URL(string: "http://localhost:8080/")
    
    typealias MinutesToPrepare = Int
    
    // Get Categories
    func fetchCategories(completion: @escaping(Result<[String], Error>) -> Void) {
        let categoriesURL = baseURL?.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoriesURL!) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let categoryResponse = try jsonDecoder.decode(CategoryResponse.self, from: data)
                completion(.success(categoryResponse.categories))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Get MenuItems
     func fetchMenuItems(forCategory categoryName: String, completion: @escaping(Result<[MenuItem], Error>) -> Void) {
         let menuItemURL = baseURL?.appendingPathComponent("menu")
         var components = URLComponents(url: menuItemURL!, resolvingAgainstBaseURL: true)!
         components.queryItems = [
             URLQueryItem(name: "category", value: categoryName)
         ]
         let menuURL = components.url!
         
         let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
             guard let data = data else {
                 return
             }
             
             do {
                 let jsonDecoder = JSONDecoder()
                 let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
                 completion(.success(menuResponse.items))
             }
             catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }

    
    // Post Order
    func submitOrder(forMenuIDs menuIDs: [Int], completion:
                     @escaping (Result<MinutesToPrepare, Error>) -> Void) {
        let orderURL = baseURL!.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        // submitOrder
        let task = URLSession.shared.dataTask(with: request)
           { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try
                       jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Fetch Image
    func fetchImage(with url: URL, completion:@escaping(UIImage?) -> Void) {
        let taks = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data)
            {
                 completion(image)
            } else {
                completion(nil)
            }
        }
        
        taks.resume()
    }
    
    // State Restoration Controller
    func updateUserActivity(with controller: StateRestorantionController) {
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .order, .categories:
            break
        }
        
        userActivity.controllerIdentifier = controller.identifier
    }
 }
