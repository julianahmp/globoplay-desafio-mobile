//
//  DataPersistentManagerMock.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 21/11/24.
//

import CoreData
import UIKit

@testable import DesafioGloboPlay

class DataPersistentManager {
    
    static let shared = DataPersistentManager()
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)) {
        self.context = context
    }
    
    enum DataBaseError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
    }
    
    func downloadMediaWith(model: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let item = MediaObject(context: context)
        item.id = Int64(model.id)
        item.name = model.name
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.original_language = model.original_language
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSave))
        }
    }
    
    func fetchMediaFromDatabse(completion: @escaping (Result<[MediaObject], Error>) -> Void) {
        let request: NSFetchRequest<MediaObject> = MediaObject.fetchRequest()
        do {
            let mediaObjects = try context.fetch(request)
            completion(.success(mediaObjects))
        } catch {
            completion(.failure(DataBaseError.failedToFetch))
        }
    }
    
    func deleteMediaWith(model: MediaObject, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            context.delete(model)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
}
