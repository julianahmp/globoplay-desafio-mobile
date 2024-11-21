//
//  HomeViewModel.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 21/11/24.
//

import Foundation

class HomeViewModel {
    private let service = NetworkService.shared

    func fetchData(for section: Sections, completion: @escaping (Result<[Media], Error>) -> Void) {
        switch section {
        case .Trending:
            service.getTrendings { result in
                completion(result.map { $0.results })
            }
        case .Movie:
            service.getMovies { result in
                completion(result.map { $0.results })
            }
        case .TV:
            service.getTVs { result in
                completion(result.map { $0.results })
            }
        }
    }
}
