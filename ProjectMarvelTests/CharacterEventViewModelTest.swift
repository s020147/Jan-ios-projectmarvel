//
//  CharacterEventViewModelTest.swift
//  ProjectMarvelTests
//
//  Created by Dustin Tong on 2/11/24.
//

import XCTest
@testable import ProjectMarvel

class CharacterEventViewModelTest: XCTestCase {
    var systemUnderTest: CharacterEventViewModel?
    override func setUp(){
        self.systemUnderTest = CharacterEventViewModel(serviceManager: MockCharacterService(isTestingHappyPath: true))
    }

    override func tearDown() {
    }

    func testGetAllCharacters() {
        let expectation = self.expectation(description: "fetchAllCharacters")

        self.systemUnderTest?.getAllCharacters(onSuccess: {
            expectation.fulfill()
        }, onFailure: { error in
            XCTFail("Error occurred: \(error)")
        })

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        XCTAssertNotNil(self.systemUnderTest?.characters, "Characters should not be nil")
        XCTAssertFalse(self.systemUnderTest?.characters.isEmpty ?? true, "Characters array should not be empty")

    }
    
    func testGetAllCharactersError() {
        let expectation = self.expectation(description: "fetchAllCharacters")
        self.systemUnderTest = CharacterEventViewModel(serviceManager: MockCharacterService(isTestingHappyPath: false))
        self.systemUnderTest?.getAllCharacters(onSuccess: {
            XCTFail("Should not get anything")
        }, onFailure: { error in
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        XCTAssertTrue(self.systemUnderTest?.characters.isEmpty ?? true, "Characters array should not be empty")
    }
}
