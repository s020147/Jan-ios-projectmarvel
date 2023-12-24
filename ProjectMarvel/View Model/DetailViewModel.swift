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

class DetailViewModel {

    var character: CharacterResult
    var wikiPage: String? {
        get {
            character.urls.filter { urlElement in
                urlElement.type == .wiki
            }
            .first?.url
        }
    }
    
    init(character: CharacterResult) {
        self.character = character
    }
    
    // We don't even call anything here?
    func getCharacterImageURL(for indexPath: IndexPath, isSearchActive: Bool) -> URL? {
        let path = character.thumbnail.path.replacingOccurrences(of: "http", with: "https")
        let thumbnailExtension = character.thumbnail.thumbnailExtension
        guard let url = URL(string: "\(path).\(thumbnailExtension.rawValue)") else {
            return nil
        }
        return url
    }
}
