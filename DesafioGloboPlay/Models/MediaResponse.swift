//
//  MediaResponse.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 17/11/24.
//

import Foundation

struct MediaResponse<T: Codable>: Codable {
    let results: [T]
}

struct Media: Codable {
    let id: Int
    let name: String?
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let media_type: String?
    let original_language: String?
}

typealias Movie = Media
typealias Trending = Media
typealias TV = Media

