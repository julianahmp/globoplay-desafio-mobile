//
//  HomeMediaTableViewCell.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 16/11/24.
//

import UIKit
import SDWebImage

protocol HomeMediaTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: HomeMediaTableViewCell, model: Media)
}

class HomeMediaTableViewCell: UITableViewCell {
    
    weak var delegate: HomeMediaTableViewCellDelegate?
    
    private var medias = [Media]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.mediaCollectionViewCellIdentifier)
        collectionView.backgroundColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.customGray
            } else {
                return UIColor.white
            }
        }
        return collectionView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with medias: [Media]) {
        self.medias = medias
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionView

extension HomeMediaTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCollectionViewCellIdentifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: medias[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let media = medias[indexPath.row]
        
        self.delegate?.didTapCell(self, model: media)
    }
}
