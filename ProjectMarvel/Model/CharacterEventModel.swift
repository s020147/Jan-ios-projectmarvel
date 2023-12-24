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

// MARK: - DataModel
public struct DataModel: Codable {
    let code: Int
    let status: String
    let etag: String
    let data: DataClass
    
    public init() {
        self.code = 14
        self.status = "status"
        self.etag = "tagHEre"
        self.data = DataClass(offset: 14, limit: 24, total: 100, count: 10, results: [CharacterResult(id: 1009144, name: "A.I.M.", resultDescription: "AIM is a terrorist organization bent on destroying the world.", modified: "2013-10-17T14:41:30-0400", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec", thumbnailExtension: ProjectMarvel.Extension.jpg), resourceURI: "resource", comics: Comics(available: 10, collectionURI: "1", items: [], returned: 31), series: Comics(available: 10, collectionURI: "1", items: [], returned: 31), stories: Stories(available: 32, collectionURI: "3232", items: [], returned: 32), events: Comics(available: 10, collectionURI: "1", items: [], returned: 31), urls: [])])
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int
    let results: [CharacterResult]
}

// MARK: - Result
public struct CharacterResult: Codable {
    let id: Int
    let name, resultDescription: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
public struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}

// MARK: - ComicsItem
public struct ComicsItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Stories
public struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

// MARK: - StoriesItem
public struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: String
}

// MARK: - Thumbnail
public struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

public enum Extension: String, Codable {
    case gif = "gif"
    case jpg = "jpg"
    case png = "png"
}

// MARK: - URLElement
public struct URLElement: Codable {
    let type: URLType
    let url: String
}

public enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
