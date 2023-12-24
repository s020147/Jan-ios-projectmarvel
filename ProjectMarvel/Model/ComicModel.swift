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

