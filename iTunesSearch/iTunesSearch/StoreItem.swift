//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Rajveer Singh on 31/10/22.
//

import Foundation

struct StoreItem: Codable {
    
    let name: String?
    let artist: String
    let kind: String
    let description: String
    let artworkURL: URL
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? values.decode(String.self, forKey: CodingKeys.name)) ?? "Anonymous"
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = (try? values.decode(String.self, forKey: CodingKeys.kind)) ?? "Unknown"
        artworkURL = (try values.decode(URL.self, forKey: CodingKeys.artworkURL))
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            
            self.description = description
        } else {
            
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description = "shortDescription"
        case artworkURL = "artworkUrl100"
    }
    
    enum AdditionalKeys: String, CodingKey {
        
        case longDescription
    }
}

struct SearchResponse: Codable {
    
    let results: [StoreItem]
}
