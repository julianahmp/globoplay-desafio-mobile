//
//  DataPersistentManager.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 19/11/24.
//

import Foundation
import UIKit
import CoreData

class DataPersistentManager {
    
    static let shared = DataPersistentManager()
    
    enum DataBaseError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
    }
    
    func downloadMediaWith(model: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
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
        } catch  {
            completion(.failure(DataBaseError.failedToSave))
        }
    }
    
    func fetchMediaFromDatabse(completion: @escaping (Result<[MediaObject], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MediaObject> = MediaObject.fetchRequest()
        
        do {
            let mediaObjects = try context.fetch(request)
            completion(.success(mediaObjects))
        } catch  {
            completion(.failure(DataBaseError.failedToFetch))
        }
    }
    
    func deleteMediaWith(model: MediaObject, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            context.delete(model)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
}
