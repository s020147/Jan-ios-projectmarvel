//
//  Created by Dustin Tong on 2/14/24.
//


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
