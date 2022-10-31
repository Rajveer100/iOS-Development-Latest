import UIKit

extension Data {
    
    func prettyPrintedJSONString() {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
            
            print("Failed to read JSON Object.")
            return
        }
        
        print(prettyJSONString)
    }
}

enum ItemInfoError: Error, LocalizedError {
    
    case itemNotFound
}

struct StoreItem: Codable {
    
    let name: String?
    let artist: String
    let kind: String
    let description: String
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? values.decode(String.self, forKey: CodingKeys.name)) ?? "Anonymous"
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = (try? values.decode(String.self, forKey: CodingKeys.kind)) ?? "Unknown"
        
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
    }
    
    enum AdditionalKeys: String, CodingKey {
        
        case longDescription
    }
}

struct SearchResponse: Codable {
    
    let results: [StoreItem]
}

let query = [
    
    "term": "Apple",
    "media": "all"
]

func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
    
    let url = "https://itunes.apple.com/search"

    var urlComponents = URLComponents(string: url)!
    
    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200 {
        
        print(data.prettyPrintedJSONString())
        
        let jsonDecoder = JSONDecoder()
        
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
    }
    
    throw ItemInfoError.itemNotFound
}

Task {
    
    do {
        
        let storeItems = try await fetchItems(matching: query)
        
        print("Successfully fetched Item Info: \(storeItems)")
        
        storeItems.forEach { item in
            
            print("""
                    
                    Name: \(item.name!)
                    Artist: \(item.artist)
                    Kind: \(item.kind)
                    Description: \(item.description)
                    
                    """)
        }
    } catch {
        
        print("Fetch Items failed with error: \(error)")
    }
}
