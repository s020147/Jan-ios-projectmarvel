//
//  Created by Dustin Tong on 2/14/24.
//


import Foundation

struct RequestData {
    let baseURL: String
    let path: String
    let httpMethod: HTTPMethod
    let parameters: [String:Any]?
    let headers: [String:String]?
    
    init(baseURL: String = "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=\(Environment.apiKey)\(Environment.hash)", path: String, httpMethod: HTTPMethod = .get, parameters: [String:Any]? = nil, headers: [String:String]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.headers = headers
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
