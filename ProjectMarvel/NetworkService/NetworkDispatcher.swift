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

struct NetworkDispatcher {
    private func createRequest(for requestData: RequestData) -> URLRequest? {
        var urlString = requestData.baseURL
        
        // adding parameters to URL
        if let parameters = requestData.parameters {
            parameters.forEach { parameter in
                urlString += parameter.key + "=" + "\(parameter.value)" + "&"
            }
        }
        
        // creating a request
        guard let URL = URL(string: urlString) else {return nil}
        var urlRequest = URLRequest(url: URL)
        urlRequest.httpMethod = requestData.httpMethod.rawValue
        
        if let headers = requestData.headers {
            headers.forEach { header in
                if let headerKey = header.key as String? {
                    urlRequest.setValue(header.value, forHTTPHeaderField: headerKey)
                }
            }
        }
        return urlRequest
    }
    
    func dispatch(for requestData:RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let urlRequest = createRequest(for: requestData) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                onError(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // add custom error object here
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let data = data else { return }
                onSuccess(data)
            case 400...499:
                if let error = error {
                    onError(error)
                }
            case 500...599:
                if let error = error {
                    onError(error)
                }
            default:
                if let error = error {
                    onError(error)
                }
            }
        }.resume()
    }
}
