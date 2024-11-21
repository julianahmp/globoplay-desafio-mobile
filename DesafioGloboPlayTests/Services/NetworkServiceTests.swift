//
//  NetworkServiceTests.swift
//  DesafioGloboPlayTests
//
//  Created by Juliana Marchl on 14/11/24.
//

import XCTest
import Alamofire

@testable import DesafioGloboPlay

class NetworkServiceTests: XCTestCase {
    
    var service: NetworkService!
    
    override func setUp() {
        super.setUp()
        service = NetworkService()
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
    }
    
    func test_getTrendingsReturnsWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch Trendings")
        var fetchedTrendings: [Trending]?
        
        NetworkService.shared.getTrendings { result in
            switch result {
            case .success(let response):
                fetchedTrendings = response.results
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(fetchedTrendings, "List returned with success!")
    }
    
    func test_getMoviesReturnsWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch Movies")
        var fetchedMovies: [Movie]?
        
        NetworkService.shared.getMovies { result in
            switch result {
            case .success(let response):
                fetchedMovies = response.results
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(fetchedMovies, "List returned with success!")
    }
    
    func test_getTVsReturnsWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch TV Shows")
        var fetchedTVs: [TV]?
        
        NetworkService.shared.getTVs { result in
            switch result {
            case .success(let response):
                fetchedTVs = response.results
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(fetchedTVs, "List returned with success!")
    }
}




