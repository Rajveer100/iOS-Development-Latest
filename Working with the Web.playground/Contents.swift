import UIKit

struct PhotoInfo: Codable {
    
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

enum PhotoInfoError: Error, LocalizedError {
    
    case itemNotFound
}

func fetchPhotoInfo() async throws -> PhotoInfo {
    
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!

    urlComponents.queryItems = ["api_key": "ptMeXQtXfcUW2AfkPoesONZb7eGuoulUgXUjDLQn",
                                "date": "2013-07-16"].map { URLQueryItem(name: $0.key, value: $0.value) }

    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    let jsonDecoder = JSONDecoder()
    
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200,
       let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
        
        return photoInfo
    }
    
    throw PhotoInfoError.itemNotFound
}

Task {
    
    do {
        
        let photoInfo = try await fetchPhotoInfo()
        
        print("Successfully fetched PhotoInfo: \(photoInfo)")
    } catch {
        
        print("Fetch PhotoInfo failed with error: \(error)")
    }
}
