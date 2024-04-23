//
//  Created by Dustin Tong on 2/14/24.
//

import SwiftUI

// MARK: - DetailCardModel4
struct DetailCardModel4: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: SeriesData
}

// MARK: - SeriesData
struct SeriesData: Codable {
    let offset, limit, total, count: Int
    let results: [SeriesList]
}

// MARK: - SeriesList
struct SeriesList: Codable {
    let id: Int
    let title: String
    let resultDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
    }
}
