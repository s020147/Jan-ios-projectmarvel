//
//  Created by Dustin Tong on 2/14/24.
//


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
