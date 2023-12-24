//
//  MockCharacterService.swift
//  ProjectMarvelTests
//
//  Created by Dustin Tong on 2/11/24.
//

import Foundation
import ProjectMarvel

public enum TestError: Error {
    case mockTestError
}
class MockCharacterService: CharacterServiceProtocol {
    var isTestingHappyPath: Bool = true
    
    init(isTestingHappyPath: Bool) {
        self.isTestingHappyPath = isTestingHappyPath
    }
    
    func fetchAllCharacters(completion: @escaping (Result<ProjectMarvel.DataModel, Error>) -> Void) {
        if isTestingHappyPath {
            completion(.success(DataModel()))
        } else {
            completion(.failure(TestError.mockTestError))
        }
    }
    
    func fetchCharactersStartingWith(_ searchText: String, completion: @escaping (Result<ProjectMarvel.DataModel, Error>) -> Void) {
        return
    }
    
    func fetchNextCharacters(searchText: String, offSet: Int, isSearchActive: Bool, completion: @escaping (Result<ProjectMarvel.DataModel, Error>) -> Void) {
        return
    }

}
