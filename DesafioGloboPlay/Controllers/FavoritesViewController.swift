//
//  FavoritesViewController.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 14/11/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var favoriteMedias: [MediaObject] = [MediaObject]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.mediaCollectionViewCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigationBar()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        applyConstraints()
        
        setupNotificationCenter()
        
        fetchLocalStorageForFavorites()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocalStorageForFavorites), name: .didUpdatedFavorites, object: nil)
    }
    
    func setupBackground() {
        view.backgroundColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.customGray
            } else {
                return UIColor.white
            }
        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            },
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = Constants.myList
        navigationItem.backButtonTitle = Constants.emptyString
    }
    
    @objc private func fetchLocalStorageForFavorites() {
        DataPersistentManager.shared.fetchMediaFromDatabse { [weak self] result in
            switch result {
            case .success(let medias):
                self?.favoriteMedias = medias
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMedias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCollectionViewCellIdentifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: favoriteMedias[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let favoriteMedia = favoriteMedias[indexPath.row]
        
        let media = Media(id: Int(favoriteMedia.id),
                          name: favoriteMedia.name,
                          original_name: favoriteMedia.original_name,
                          overview: favoriteMedia.overview,
                          poster_path: favoriteMedia.poster_path,
                          media_type: favoriteMedia.media_type,
                          original_language: favoriteMedia.original_language)
        
        DispatchQueue.main.async {
            let vc = MediaViewController()
            vc.configure(with: media)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
