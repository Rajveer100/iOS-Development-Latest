//
//  MenuController.swift
//  OrderApp
//
//  Created by Rajveer Singh on 03/11/22.
//

import Foundation
import UIKit

typealias MinutesToPrepare = Int

class MenuController {
    
    static let shared = MenuController()
    var userActivity = NSUserActivity(activityType: "com.rajveersingh.OrderApp.order")
    
    var order = Order() {
        
        didSet {
            
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            userActivity.order = order
        }
    }
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func fetchCategories() async throws -> [String] {
        
        let categoriesURL = baseURL.appending(path: "categories")
        
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        guard let httpReponse = response as? HTTPURLResponse,
              httpReponse.statusCode == 200 else {
            
            throw MenuControllerError.categoriesNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesResponse.categories
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        
        let baseMenuURL = baseURL.appending(path: "menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        
        let menuURL = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpReponse = response as? HTTPURLResponse,
              httpReponse.statusCode == 200 else {
            
            throw MenuControllerError.menuItemsNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let menuReponse = try jsonDecoder.decode(MenuResponse.self, from: data)
        
        return menuReponse.items
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        
        let orderURL = baseURL.appending(path: "order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let menuIdsDict = ["menuIds": menuIDs]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(menuIdsDict)
        
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpReponse = response as? HTTPURLResponse,
              httpReponse.statusCode == 200 else {
            
            throw MenuControllerError.orderRequestFailed
        }
        
        let jsonDecoder = JSONDecoder()
        let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            
            throw MenuControllerError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            
            throw MenuControllerError.imageDataMissing
        }
        
        return image
    }
    
    func updateUserActivity(with controller: StateRestorationController) {
        
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

enum MenuControllerError: Error, LocalizedError {
    
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
    case imageDataMissing
}
