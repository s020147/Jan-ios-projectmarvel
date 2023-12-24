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

//protocol ErrorHandlingDelegate: AnyObject {
//    func handle(error: Error)
//}
//
//protocol CharacterEventViewModelDelegate: ErrorHandlingDelegate {
//
//}

class CharacterEventViewModel {
    //    typealias ErrorHandler = (Error) -> Void
    //    weak var delegate: ErrorHandlingDelegate?
    //    var errorHandler: ErrorHandler?
    var results:[CharacterResult] {
        result?.data.results ?? []
    }
    var filtered:[CharacterResult] = []
    var result: DataModel?
    var characters: [CharacterResult] = []
    var searchResults: DataModel?
    private let networkDispatcher = NetworkDispatcher()
    private let sourceURL = "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=\(Environment.apiKey)\(Environment.hash)"
    let serviceManager: CharacterServiceProtocol
    
    init(serviceManager: CharacterServiceProtocol){
        self.serviceManager = serviceManager
    }
    
    func getCharacterImageURL(for indexPath: IndexPath, isSearchActive: Bool) -> URL? {
        let character = isSearchActive ? filtered[indexPath.row] : characters[indexPath.row]
        let path = character.thumbnail.path.replacingOccurrences(of: "http", with: "https")
        let thumbnailExtension = character.thumbnail.thumbnailExtension
        guard let url = URL(string: "\(path).\(thumbnailExtension.rawValue)") else {
            return nil
        }
        return url
    }
    
    public func getAllCharacters(onSuccess: @escaping () -> (), onFailure: @escaping(Error) -> Void) {
        self.serviceManager.fetchAllCharacters(completion: { result in
            switch result {
            case .success(let dataModel):
                self.result = dataModel
                self.characters = self.result?.data.results ?? []
                onSuccess()
            case .failure(let error):
                onFailure(error)
            }
        })
    }
    
    func filterNames(_ searchText: String, onSuccess: @escaping () -> (), onFailure: @escaping(Error) -> Void) {
        let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        let requestData = RequestData(path: "", parameters: ["&nameStartsWith": "\(searchText)"])
        performRequest(requestData: requestData) { dataModel in
            self.searchResults = dataModel
            self.filtered = dataModel.data.results
            onSuccess()
        } onError: { error in
            onFailure(error)
        }
    }
    
    func getNextCharacters(searchText: String = "", isSearchActive: Bool, completion: @escaping () -> ()) {
        // updated from PR
        guard let totalAvailable = isSearchActive ? searchResults?.data.total : result?.data.total else {
            assertionFailure("Unable to get total from previously fetched results")
            return
        }
        let numOfFetchedCharacters = isSearchActive ? filtered.count : characters.count
        if totalAvailable <= numOfFetchedCharacters {
            return
        }
        
        let offSet = isSearchActive ? filtered.count : characters.count
        serviceManager.fetchNextCharacters(searchText: searchText, offSet: offSet, isSearchActive: isSearchActive) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    if isSearchActive {
                        self?.filtered.append(contentsOf: dataModel.data.results)
                        self?.searchResults = dataModel
                    } else {
                        self?.characters.append(contentsOf: dataModel.data.results)
                        self?.result = dataModel
                    }
                    completion()
                case .failure(let error):
                    completion()
                }
            }
        }
    }
    
    func getName(for indexPath: IndexPath, searchIsActive: Bool = false) -> String? {
        if (searchIsActive) {
            return filtered[indexPath.row].name
        }
        return characters[indexPath.row].name
    }
    
    func getCharacter(for indexPath: IndexPath, searchIsActive: Bool = false) -> CharacterResult? {
        if (searchIsActive) {
            return filtered[indexPath.row]
        }
        return characters[indexPath.row]
    }
    
    func getNumOfCharacters(searchIsActive: Bool = false) -> Int {
        if (searchIsActive) {
            return filtered.count
        }
        return characters.count
    }
    
    func performRequest(requestData: RequestData, onSuccess: @escaping(DataModel) -> Void, onError: @escaping(Error) -> Void) {
        
        networkDispatcher.dispatch(for: requestData, onSuccess: { data in
            do {
                let jsonData = try JSONDecoder().decode(DataModel.self, from: data)
                onSuccess(jsonData)
            }
            catch {
                print("Unable to parse response: \(error)")
            }
        }, onError: { error in
            onError(error)
        })
    }
}
