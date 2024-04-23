//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

// MARK: - DetailCardModel2
struct DetailCardModel2: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: ComicData
}

// MARK: - ComicData
struct ComicData: Codable {
    let offset, limit, total, count: Int
    let results: [ComicList]
}

// MARK: - ComicList
struct ComicList: Codable {
    let id: Int
    let title: String
    let resultDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case resultDescription = "description"
    }
}

