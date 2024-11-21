//
//  MediaViewModel.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 20/11/24.
//

import Foundation
import UIKit

class MediaViewModel {
    private let userDefaults = UserDefaultsManager.shared
    
    var media: Media?
    
    var alsoWatchMedias: [Media] = [Media]()
    
    var favoritesButtonTitle: String?
    
    init() { }
    
    func toggleFavoritesState(isAdding: Bool) {
        favoritesButtonTitle = isAdding ? Constants.addedToList : Constants.addToList
        
        let notificationName: Notification.Name = isAdding ? .didAddToList : .didAddedToList
        
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func configure(with model: Media) {
        NotificationCenter.default.post(name: .didUpdateModel, object: model)
        media = model
    }
    
    func addToFavorites(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let media = media else {
            completion(.failure(ErrorTypes.mediaNotFound))
            return
        }
        
        DataPersistentManager.shared.fetchMediaFromDatabse { result in
            switch result {
            case .success(let mediaObjects):
                if mediaObjects.first(where: { $0.id == media.id }) != nil {
                    self.userDefaults.saveFavoritesButtonStateForTitle(forID: media.id, title: Constants.addedToList)
                } else {
                    DataPersistentManager.shared.downloadMediaWith(model: media, completion: completion)
                    self.userDefaults.saveFavoritesButtonStateForTitle(forID: media.id, title: Constants.addedToList)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFromFavorites(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let media = media else { return }
        
        DataPersistentManager.shared.fetchMediaFromDatabse { result in
            switch result {
            case .success(let mediaObjects):
                if let mediaObject = mediaObjects.first(where: { $0.id == media.id }) {
                    DataPersistentManager.shared.deleteMediaWith(model: mediaObject, completion: completion)
                    self.userDefaults.saveFavoritesButtonStateForTitle(forID: media.id, title: Constants.addToList)
                } else {
                    self.userDefaults.saveFavoritesButtonStateForTitle(forID: media.id, title: Constants.addToList)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTrendingData(for cell: MediaCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        NetworkService.shared.getTrendings { result in
            switch result {
            case .success(let trendingResponse):
                self.alsoWatchMedias.append(contentsOf: trendingResponse.results)
                cell.configure(with: trendingResponse.results[indexPath.row].poster_path ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
}
