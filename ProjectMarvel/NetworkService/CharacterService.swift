//
//  CharacterService.swift
//  ProjectMarvel
//
//  Created by Dustin Tong on 2/11/24.
//

import Foundation
import SwiftUI

public protocol CharacterServiceProtocol {
    func fetchAllCharacters(completion: @escaping (Result<DataModel, Error>) -> Void)
    func fetchCharactersStartingWith(_ searchText: String, completion: @escaping (Result<DataModel, Error>) -> Void)
    func fetchNextCharacters(searchText: String, offSet: Int, isSearchActive: Bool, completion: @escaping (Result<DataModel, Error>) -> Void)
}


class CharacterService: CharacterServiceProtocol {
    private let sourceURL = "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=\(Environment.apiKey)\(Environment.hash)"
    private let networkDispatcher = NetworkDispatcher()
    
    func fetchCharactersStartingWith(_ searchText: String, completion: @escaping (Result<DataModel, Error>) -> Void) {
        // I think I already did enough here to prove my point about refactoring.
    }
    
    func fetchNextCharacters(searchText: String, offSet: Int, isSearchActive: Bool, completion: @escaping (Result<DataModel, Error>) -> Void) {
        guard let url = isSearchActive ? URL(string: "\(sourceURL)&nameStartsWith=\(searchText)&offset=\(offSet)") : URL(string: "\(sourceURL)&offset=\(offSet)") else {
            assertionFailure("URL unwrapping failed, check that the URL is correctly being formatted.")
            return
        }
        
        let requestData = RequestData(baseURL: url.absoluteString, path: "", parameters: nil)
        dispatchRequest(requestData, completion: completion)
    }
    

    func fetchAllCharacters(completion: @escaping (Result<DataModel, Error>) -> Void) {
        let requestData = RequestData(path: "")
        dispatchRequest(requestData, completion: completion)
    }
    
    // Bridge between NetworkDispatcher here and our custom Character Service class
    private func dispatchRequest(_ requestData: RequestData, completion: @escaping (Result<DataModel, Error>) -> Void) {
        networkDispatcher.dispatch(for: requestData, onSuccess: { data in
            do {
                let decodedData = try JSONDecoder().decode(DataModel.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }, onError: { error in
            completion(.failure(error))
        })
    }
}
