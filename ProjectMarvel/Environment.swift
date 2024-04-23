//
//  Created by Dustin Tong on 2/14/24.
//


import Foundation

public enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
        static let hash = "HASH"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not set in plist")
        }
        return apiKeyString
    }()
    
    static let hash: String = {
        guard let hashString = Environment.infoDictionary[Keys.hash] as? String else {
            fatalError("Hash not set in plist")
        }
        return hashString
    }()
}
