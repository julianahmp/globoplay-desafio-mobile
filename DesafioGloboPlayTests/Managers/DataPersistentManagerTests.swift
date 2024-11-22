//
//  DataPersistentManagerTests.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 21/11/24.
//

import XCTest
import CoreData

@testable import DesafioGloboPlay

class DataPersistentManagerTests: XCTestCase {

    var mockPersistentContainer: NSPersistentContainer!
    var dataManager: DataPersistentManager!
    
    override func setUpWithError() throws {
        super.setUp()
        mockPersistentContainer = {
            let container = NSPersistentContainer(name: "GloboPlayModel")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Mock container setup failed: \(error)")
                }
            }
            return container
        }()
        dataManager = DataPersistentManager(context: mockPersistentContainer.viewContext)
    }

    override func tearDownWithError() throws {
        dataManager = nil
        mockPersistentContainer = nil
        super.tearDown()
    }

    func testDownloadMediaWithSuccess() {
        let media = Media(id: 1, name: "Test Movie", original_name: "Test Movie Original", overview: "Overview", poster_path: "/test.jpg", media_type: "movie", original_language: "en")
        
        let expectation = self.expectation(description: "Save media success")
        
        dataManager.downloadMediaWith(model: media) { result in
            switch result {
            case .success():
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
        
        let request: NSFetchRequest<MediaObject> = MediaObject.fetchRequest()
        let objects = try? self.mockPersistentContainer.viewContext.fetch(request)
        
        XCTAssertEqual(objects?.count, 1)
        XCTAssertEqual(objects?.first?.name, "Test Movie")
    }
    
    func testFetchMediaFromDatabaseSuccess() {
        let mediaObject = MediaObject(context: mockPersistentContainer.viewContext)
        mediaObject.id = 1
        mediaObject.name = "Test Movie"
        try? mockPersistentContainer.viewContext.save()
        
        let expectation = self.expectation(description: "Fetch media success")
        
        dataManager.fetchMediaFromDatabse { result in
            switch result {
            case .success(let media):
                XCTAssertEqual(media.count, 1)
                XCTAssertEqual(media.first?.name, "Test Movie")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeleteMediaWithSuccess() {
        let mediaObject = MediaObject(context: mockPersistentContainer.viewContext)
        mediaObject.id = 1
        mediaObject.name = "Test Movie"
        try? mockPersistentContainer.viewContext.save()
        
        let expectation = self.expectation(description: "Delete media success")
        
        dataManager.deleteMediaWith(model: mediaObject) { result in
            switch result {
            case .success():
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
        
        let request: NSFetchRequest<MediaObject> = MediaObject.fetchRequest()
        let objects = try? self.mockPersistentContainer.viewContext.fetch(request)
        
        XCTAssertEqual(objects?.count, 0)
    }
}

