import UIKit

enum APIRequestError: Error {
    
    case itemNotFound
}

protocol APIRequest {
    
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    
    func decodedResponse(data: Data) throws -> Response
}

func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
    
    let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        
        throw APIRequestError.itemNotFound
    }
    
    let decodedResponse = try request.decodedResponse(data: data)
    
    return decodedResponse
}

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

struct PhotoInfoAPIRequest: APIRequest {
        
    var apikey: String
    
    var urlRequest: URLRequest {
        
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            URLQueryItem(name: "date", value: "2021-07-15"),
            URLQueryItem(name: "api_key", value: apikey)]
        
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodedResponse(data: Data) throws -> PhotoInfo {
        
        let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
        
        return photoInfo
    }
}

struct ImageAPIRequest: APIRequest {
    
    var url: URL
    
    var urlRequest: URLRequest {
        
        return URLRequest(url: url)
    }
    
    enum ResponseError: Error {
        
        case invalidImageData
    }
    
    func decodedResponse(data: Data) throws -> UIImage {
        
        guard let image = UIImage(data: data) else { throw ResponseError.invalidImageData }
        
        return image
    }
}

let photoInfoRequest = PhotoInfoAPIRequest(apikey: "DEMO_KEY")

Task {
    
    do {
        
        let photoInfo = try await sendRequest(photoInfoRequest)
        print(photoInfo)
        
        let imageRequest = ImageAPIRequest(url: photoInfo.url)
        let image = try await sendRequest(imageRequest)
    } catch {
        
        print(error)
    }
}
