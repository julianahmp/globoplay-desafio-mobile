//
//  UserDefaultsManager.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 20/11/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func saveFavoritesButtonStateForTitle(forID id: Int, title: String) {
        let key = "favorite_status_\(id)"
        UserDefaults.standard.set(title, forKey: key)
    }
    
    func getFavoritesButtonStateForTitle(forID id: Int) -> String {
        let key = "favorite_status_\(id)"
        return UserDefaults.standard.string(forKey: key) ?? Constants.addToList
    }
}
