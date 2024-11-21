//
//  MediaViewController.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 16/11/24.
//

import UIKit
import SDWebImage

class MediaViewController: UIViewController {
    
    private let viewModel = MediaViewModel()
    
    private let mediaView = MediaUIView()
    private let headerView = MediaHeaderUIView()
    
    override func loadView() {
        view = mediaView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaView.scrollView.delegate = self
        mediaView.alsoWatchCollectionView.delegate = self
        mediaView.alsoWatchCollectionView.dataSource = self
        mediaView.alsoWatchCollectionView.reloadData()
        
        setupSegmentedControl()
        setupNotificationCenter()
        setupInvisibleNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabBarHidden(false)
    }
    
    private func setupSegmentedControl() {
        mediaView.segmentedControl.setupSegment()
        mediaView.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddFavoritesNotification), name: .didAddToList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRemoveFavoritesNotification), name: .didAddedToList, object: nil)
    }
    
    private func isTabBarHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isTranslucent = isHidden
        tabBarController?.tabBar.isHidden = isHidden
    }
    
    private func setupVisibleNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.customGray
            } else {
                return UIColor.white
            }
        }
        navigationController?.navigationBar.tintColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.title = headerView.navigationTitle ?? Constants.emptyString
    }
    
    private func setupInvisibleNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.title = Constants.emptyString
    }
    
    func configure(with model: Media) {
        viewModel.configure(with: model)
        guard let posterPath = model.poster_path else { return }
        mediaView.backgroundBlurredImageView.sd_setImage(with: URL(string: Constants.imgUrl + posterPath))
    }
    
    @objc private func segmentChanged() {
        mediaView.segmentedControl.setupSegment()
        let isDetailsSelected = mediaView.segmentedControl.selectedSegmentIndex == 0
        mediaView.detailsContainerView.isHidden = isDetailsSelected
        mediaView.alsoWatchCollectionView.isHidden = !isDetailsSelected
    }
    
    @objc private func handleAddFavoritesNotification() {
        viewModel.addToFavorites { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: .didUpdatedFavorites, object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func handleRemoveFavoritesNotification() {
        viewModel.removeFromFavorites { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: .didUpdatedFavorites, object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MediaViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 50 {
            setupVisibleNavigationBar()
        } else {
            setupInvisibleNavigationBar()
        }
    }
}

// MARK: - AlsoWatchUICollectionViewCell

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMedia = viewModel.alsoWatchMedias[indexPath.row]
        
        let mediaDetailVC = MediaViewController()

        mediaDetailVC.configure(with: selectedMedia)
        
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(mediaDetailVC)
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCollectionViewCellIdentifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        return viewModel.fetchTrendingData(for: cell, at: indexPath)
    }
}
