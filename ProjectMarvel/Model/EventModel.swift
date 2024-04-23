//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

// MARK: - DetailCardModel3
struct DetailCardModel3: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: EventData
}

// MARK: - EventData
struct EventData: Codable {
    let offset, limit, total, count: Int
    let results: [EventList]
}

// MARK: - EventList
struct EventList: Codable {
    let id: Int
    let title: String
    let resultDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
    }
}
