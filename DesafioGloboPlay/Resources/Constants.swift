//
//  Constants.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 17/11/24.
//

import Foundation
import Alamofire

struct Constants {
    /// API constants
    static let trendingUrl = "https://api.themoviedb.org/3/trending/all/day"
    static let movieUrl = "https://api.themoviedb.org/3/trending/movie/day"
    static let tvUrl = "https://api.themoviedb.org/3/trending/tv/day"
    static let imgUrl = "https://image.tmdb.org/t/p/w500/"
    static let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4M2VlNDgyOWYwN2U3ODI4YTlhMTFmNTI5MmMyMmUwMyIsIm5iZiI6MTczMTg3NjY1Ni43MjQzNTUyLCJzdWIiOiI2Mjg2NTQ1ODFhMzI0ODFiZDc2YWExNGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0._CWRh4lLkm0z0vh-3AqPdlMqyfxka03NOCcywfqv2mk"
    ]
    static let parameters: Parameters = [
        "language": "en-US"
    ]
    
    /// Cell register constants
    static let mediaCollectionViewCellIdentifier = "MediaCollectionViewCell"
    static let homeMediaTableViewCellIdentifier = "HomeMediaTableViewCellIdentifier"
    
    /// Atributtes constants
    static let tabBarHomeIcon = "house.fill"
    static let tabBarFavoritesIcon = "star.fill"
    static let tabBarHomeIconTitle = "Início"
    static let tabBarFavoritesIconTitle = "Minha lista"
    static let emptyString = ""
    static let details = "Detalhes"
    static let watchToo = "Assista também"
    static let globoplay = "globoplay"
    static let sectionTitles: [String] = ["Tendências", "Cinema", "Séries"]
    static let originalTitle = "Título Original: "
    static let mediaType = "Tipo de Mídia: "
    static let originalLanguage = "Idioma Original: "
    static let overview = "Sinopse: "
    static let technicalSheet = "Ficha técnica"
    static let watch = "▶ Assistir"
    static let addToList = "★ Minha lista"
    static let addedToList = "✓ Adicionado"
    static let myList = "Minha lista"
}
