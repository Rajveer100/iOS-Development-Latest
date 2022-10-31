//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Rajveer Singh on 31/10/22.
//

import Foundation
import UIKit

class StoreItemController {
    
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        
        let url = "https://itunes.apple.com/search"

        var urlComponents = URLComponents(string: url)!
        
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            
            let jsonDecoder = JSONDecoder()
            
            let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
            
            return searchResponse.results
        }
        
        throw ItemInfoError.itemNotFound
    }
    
    func fetchArtworkImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            
            throw ItemInfoError.itemNotFound
        }
        
        return image
    }
}

enum ItemInfoError: Error, LocalizedError {
    
    case itemNotFound
}
