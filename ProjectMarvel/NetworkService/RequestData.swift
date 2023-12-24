// -------------------------------------------------------------------------
// This item is the property of ResMed Ltd, and contains confidential and trade
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2022 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------

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
