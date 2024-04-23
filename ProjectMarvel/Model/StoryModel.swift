//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

// MARK: - DetailCardModel
struct DetailCardModel: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: StoryData
}

// MARK: - StoryData
struct StoryData: Codable {
    let offset, limit, total, count: Int
    let results: [StoryList]
}

// MARK: - StoryList
struct StoryList: Codable {
    let id: Int
    let title: String
    let resultDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
    }
}
