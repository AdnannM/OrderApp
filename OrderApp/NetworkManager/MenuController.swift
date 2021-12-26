//
//  MenuController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 25.12.21.
//

import Foundation

class MenuController {
    static let shared = MenuController()
    
    let baseURL = URL(string: "http://localhost:8080/")
    
    typealias MinutesToPrepere = Int
    
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
    func submitOrder(forMenuItems menuID: [Int], completion: @escaping(Result<MinutesToPrepere, Error>) -> Void) {
        let orderURL = baseURL?.appendingPathComponent("order")
        var request = URLRequest(url: orderURL!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuId" : menuID]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                completion(.success(orderResponse.prepTime))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
 }
