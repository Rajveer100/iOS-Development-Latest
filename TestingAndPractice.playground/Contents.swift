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

struct Problem: Codable {
    
    let contestId: Int?
    let index: String
    let name: String
    let rating: Int?
    let tags: [String]
}

struct Submission: Codable {
    
    let id: Int
    let contestId: Int?
    let problem: Problem
    
    let verdict: String?
    let time: Int
    let memory: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case contestId
        case problem
        
        case verdict
        case time = "timeConsumedMillis"
        case memory = "memoryConsumedBytes"
    }
}

struct SearchResponse: Codable {
    
    let status: String
    let result: [Submission]
}

Task {
    
    var urlComponents = URLComponents(string: "https://codeforces.com/api/user.status")!

    urlComponents.queryItems = ["handle": "Rajveer_100",
                                "count": "10"].map { URLQueryItem(name: $0.key, value: $0.value) }
    print(urlComponents)
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200 {
        
        print(data.prettyPrintedJSONString())
        
        let decoder = JSONDecoder()
        
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        
        searchResponse.result.forEach { (submission) in
            
            print("""
                    Submission Id: \(submission.id)
                    Contest Id: \(submission.contestId!)
                    Problem: \(submission.problem)
                    Verdict: \(submission.verdict!)
                    Time: \(submission.time)
                    Memory: \(submission.memory)
                    
                    """)
        }
    }
}
