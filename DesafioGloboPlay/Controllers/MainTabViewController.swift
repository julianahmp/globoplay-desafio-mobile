//
//  MainTabViewController.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 14/11/24.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        
        homeViewController.tabBarItem.image = UIImage(systemName: Constants.tabBarHomeIcon)
        favoritesViewController.tabBarItem.image = UIImage(systemName: Constants.tabBarFavoritesIcon)
        
        homeViewController.title = Constants.tabBarHomeIconTitle
        favoritesViewController.title = Constants.tabBarFavoritesIconTitle
        
        tabBar.tintColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        tabBar.isTranslucent = false
        
        setViewControllers([homeViewController, favoritesViewController], animated: true)
    }
}

