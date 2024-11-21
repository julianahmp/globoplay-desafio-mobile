//
//  NetworkService.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 17/11/24.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    private func performRequest<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: .get, parameters: Constants.parameters, headers: Constants.headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getTrendings(completion: @escaping (Result<MediaResponse<Trending>, Error>) -> Void) {
        performRequest(url: Constants.trendingUrl, completion: completion)
    }
    
    func getMovies(completion: @escaping (Result<MediaResponse<Movie>, Error>) -> Void) {
        performRequest(url: Constants.movieUrl, completion: completion)
    }
    
    func getTVs(completion: @escaping (Result<MediaResponse<TV>, Error>) -> Void) {
        performRequest(url: Constants.tvUrl, completion: completion)
    }
}
